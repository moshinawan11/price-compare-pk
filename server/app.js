const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Sequelize, DataTypes } = require('sequelize');
const mysql = require('mysql2');
const http = require('http');
const querystring = require('querystring');
const DUMMY_PRODUCTS = require("./products_dummy_data.js");
const dummy_products = require('./products_dummy_data2.js');
//const User = require("./models/user.js");
//const Product = require('./models/product.js');
const scrapeDarazProducts = require('./scrapers/daraz.js');
const scrapePriceoyeProducts = require('./scrapers/priceoye-c.js');
const scrapeMegaProducts = require('./scrapers/mega.js');
const scrapeMyshopProducts = require('./scrapers/myshop-c.js');
const scrapeShophiveProducts = require('./scrapers/shophive-c.js');
const stringSimilarity = require('string-similarity');
const scrapeDarazTrendingProducts = require('./scrapers/daraz-trending.js');
const scrapePriceoyeTrendingProducts = require('./scrapers/priceoye-trending.js');
const DUMMY_STORES_DATA = require('./dummy_stores_data.js');
const scrapeDarazProduct = require('./scrapers/daraz2.js');
//const scrapePriceoyeProduct = require('./scrapers/priceoye2.js');
//const scrapeMegaProduct = require('./scrapers/mega3.js');
// const scrapeMyshopProduct = require('./scrapers/myshop2.js');
// const scrapeShophiveProduct = require('./scrapers/shophive2.js');

const app = express();
app.use(express.json());

// MySQL database connection
const sequelize = new Sequelize(
  'projectdb',
  'root',
  'steyngun',
   {
     host: 'DESKTOP-NATCJ0F',
     dialect: 'mysql'
   }
 );

// models/user.js

const User = sequelize.define('user', {
  user_id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  username: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  favoriteProducts: {
    type: DataTypes.TEXT,
    get() {
      const value = this.getDataValue('favoriteProducts');
      return value ? JSON.parse(value) : [];
    },
    set(value) {
      this.setDataValue('favoriteProducts', JSON.stringify(value));
    },
    defaultValue: '[]',
  },
  priceAlert: {
    type: DataTypes.TEXT, // Use TEXT data type for storing JSON data as a string
    defaultValue: JSON.stringify({}), // Default value is an empty object as a string
    get() {
      const value = this.getDataValue('priceAlert');
      return value ? JSON.parse(value) : {};
    },
    set(value) {
      this.setDataValue('priceAlert', JSON.stringify(value));
    },
  },
});

// models/product.js

const Product = sequelize.define('product', {
  product_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  price: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  imageUrl: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  productUrl: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

const defineAssociations = () => {
  User.belongsToMany(Product, { through: 'FavoriteProducts', as: 'favoriteProductsList', foreignKey: 'user_id' });
  User.belongsToMany(Product, { through: 'PriceAlertProducts', as: 'priceAlertProductsList', foreignKey: 'user_id' });

  Product.belongsToMany(User, { through: 'FavoriteProducts', as: 'usersWhoFavorited', foreignKey: 'product_id' });
  Product.belongsToMany(User, { through: 'PriceAlertProducts', as: 'usersWithPriceAlert', foreignKey: 'product_id' });
};

defineAssociations();

// Sync the model with the database
(async () => {
  try {
    await sequelize.authenticate();
    await sequelize.sync();
    console.log('Database connection has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
})();

// Signup route
app.post('/signup', async (req, res) => {
  console.log(req.body);
  const { username, password } = req.body;
  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user in the database
    const user = await User.create({
      username,
      password: hashedPassword,
    });

     // Generate a JWT token
     const expiresIn = 3600;
     const token = jwt.sign({ userId: user.user_id }, 'your_secret_key', { expiresIn });
 
     // Respond with the token and user ID
     res.json({ token, expiresIn, user_id: user.user_id });
  } catch (error) {
    // Handle errors during signup
    if(error["message"] == "Validation error"){
      res.json({ error: "Username already in use" })
    }
    else{
      res.status(500).json({ error: 'Error during signup' });
    }
  }
});

// Login route
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // Find the user in the database
    const user = await User.findOne({ where: { username } });

    // If the user doesn't exist or the password is incorrect, return an error
    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ error: 'Invalid username or password' });
    }

    // If the user is found and the password is correct, generate a JWT token
    const expiresIn = 3600;

    const token = jwt.sign({ userId: user.user_id }, 'your_secret_key', { expiresIn });

    const user_id = user.user_id;

    // Respond with the token
    res.json({ token, expiresIn, user_id });
  } catch (error) {
    // Handle errors during login
    res.status(500).json({ error: 'Error during login' });
  }
});

app.get('/get-products', authenticateToken, (req, res) => {
  res.json(DUMMY_PRODUCTS);
});

// Middleware to authenticate the JWT token
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  console.log(authHeader);
  const token = authHeader ? authHeader : null;
  console.log(token);

  if (token == null) {
    console.log("ERROR");
    return res.status(401).json({ error: "Token empty" });
  }

  jwt.verify(token, 'your_secret_key', (error, user) => {
    if (error) {
      return res.status(403).json({ error: "User not authorized" });
    }

    // Store the authenticated user in the request object
    req.user = user;

    next();
  });
}

app.get('/search', (req, res) => {
  const searchTerm = req.query.term;
  
  // Filter the dummy products based on the search term
  const matchedProducts = dummyProducts.filter(product =>
    product.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  res.json(matchedProducts);
});

// Save a product (for favoriting or setting price alert)
// app.post('/save-product', authenticateToken, async (req, res) => {
//   const { token, userID, title, price, imageURL, productURL, basePrice } = req.body;

//   try {

//     // Check if the user exists in the database
//     const user = await User.findOne({ where: { user_id: userID } });

//     if (!user) {
//       return res.status(404).json({ error: 'User not found' });
//     }

//     // Create the product entry in the Product table
//     const product = await Product.create({
//       title,
//       price,
//       imageUrl: imageURL,
//       productUrl: productURL,
//     });

//     if (!product) {
//       return res.status(500).json({ error: 'Failed to save the product' });
//     }

//     // Check if the request is for favoriting the product
//     if (!basePrice) {
//       // Add the product to the user's favoriteProductsList
//       await user.addFavoriteProducts(product);
//     } else {
//       // Add the product to the user's priceAlertProductsList along with the basePrice
//       await user.addPriceAlertProducts(product, { through: { basePrice } });
//     }

//     return res.status(200).json({ success: true });
//   } catch (error) {
//     console.error('Error occurred while saving the product:', error);
//     return res.status(500).json({ error: 'Error occurred while saving the product' });
//   }
// });

// Save a product (for favoriting or setting price alert)
app.post('/save-product', authenticateToken, async (req, res) => {
  const { title, price, imageURL, productURL, basePrice } = req.body;

  const userID = req.user.userId;

  try {
    // Check if the user exists in the database
    const user = await User.findOne({  where: { user_id: userID },
      include: [
        { model: Product, as: 'favoriteProductsList' },
        { model: Product, as: 'priceAlertProductsList'}
      ], });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Check if the product already exists in the Product table
    const product = await Product.findOne({ where: { title, price, productURL } });

    if (!product) {
      // If the product does not exist, create it in the Product table
      const newProduct = await Product.create({
        title,
        price,
        imageUrl: imageURL,
        productUrl: productURL,
      });

      if (!newProduct) {
        return res.status(500).json({ error: 'Failed to save the product' });
      }

      // Check if the request is for favoriting the product
      if (!basePrice) {
        // Add the product to the user's favoriteProductsList
        await user.addFavoriteProductsList(newProduct);
        console.log("Added new product to favorites");
      } else {
        // Add the product to the user's priceAlertProductsList along with the basePrice
        await user.addPriceAlertProductsList(newProduct, { through: { basePrice } });
      }

      return res.status(200).json({ success: true });
    } else {
      // If the product already exists, check if it is in the user's favoriteProductsList
      const isFavorite = await user.hasFavoriteProductsList(product);

      if (isFavorite) {
        // If the product is in the user's favoriteProductsList, remove it from there
        await user.removeFavoriteProductsList(product);
        console.log("Removed product from favorites");
      } else {
        // If the product is not in the user's favoriteProductsList, add it to there
        await user.addFavoriteProductsList(product);
        console.log("Added product to favorites");
      }
      return res.status(200).json({ success: true });
    }
  } catch (error) {
    console.error('Error occurred while saving the product:', error);
    return res.status(500).json({ error: 'Error occurred while saving the product' });
  }
});


// Get favorite products for a user
app.get('/get-favorite-products', authenticateToken, async (req, res) => {
  const userID = req.user.userId;

  try {
    // Find the user with the provided userID in the database
    const user = await User.findOne({ where: { user_id: userID },
      include: [
      { model: Product, as: 'favoriteProductsList' },
      ], 
  });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Get the favoriteProductsList of the user
    const favoriteProductsList = await user.getFavoriteProductsList();

    if (favoriteProductsList.length === 0) {
      return res.status(200).json({ message: 'No favorite products found' });
    }
    console.log(favoriteProductsList);
    return res.status(200).json(favoriteProductsList);
  } catch (error) {
    console.error('Error occurred while getting favorite products:', error);
    return res.status(500).json({ error: 'Error occurred while getting favorite products' });
  }
});

// Get price alert products for a user
app.get('get-price-alert-products', authenticateToken, async (req, res) => {
  const { token, userID } = req.query;

  try {
    // Authenticate user through token
    // You should implement your authentication logic here using the token

    // Find the user with the provided userID in the database
    const user = await User.findOne({ where: { user_id: userID } });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Get the priceAlertProductsList of the user
    const priceAlertProductsList = await user.getPriceAlertProductsList();

    if (priceAlertProductsList.length === 0) {
      return res.status(200).json({ message: 'No price alert products found' });
    }

    return res.status(200).json(priceAlertProductsList);
  } catch (error) {
    console.error('Error occurred while getting price alert products:', error);
    return res.status(500).json({ error: 'Error occurred while getting price alert products' });
  }
});


// app.get('/search-product', async (req, res) => {
//   const searchTerm = "apple";
  
//   try {
//     // Scrape all stores in parallel using Promise.all
//     const darazProducts = await scrapeDarazProducts(searchTerm).catch((error) => {
//       console.error('Error occurred while scraping Daraz:', error.message);
//       return []; // Return an empty array in case of error
//     });

//     const priceoyeProducts = await scrapePriceoyeProducts(searchTerm).catch((error) => {
//       console.error('Error occurred while scraping Priceoye:', error.message);
//       return []; // Return an empty array in case of error
//     });

//     const megaProducts = await scrapeMegaProducts(searchTerm).catch((error) => {
//       console.error('Error occurred while scraping Mega:', error.message);
//       return []; // Return an empty array in case of error
//     });

//     const myshopProducts = await scrapeMyshopProducts(searchTerm).catch((error) => {
//       console.error('Error occurred while scraping Myshop:', error.message);
//       return []; // Return an empty array in case of error
//     });

//     const shophiveProducts = await scrapeShophiveProducts(searchTerm).catch((error) => {
//       console.error('Error occurred while scraping Shophive:', error.message);
//       return []; // Return an empty array in case of error
//     });

//     // Combine the results from all stores into a single array
//     const allProducts = [...darazProducts, ...priceoyeProducts, ...megaProducts, ...myshopProducts, ...shophiveProducts];
//     //const allProducts = [...priceoyeProducts, ...shophiveProducts, ...myshopProducts];

//     // Return the combined product list as a response
//     console.log(allProducts);
//     console.log(allProducts.length);
//     res.send(allProducts);
//   } catch (error) {
//     console.error('Error occurred while scraping stores:', error.message);
//     res.status(500).json({ error: 'Error during scraping' });
//   }
// });

// app.get('/search-product', async (req, res) => {
//   const searchTerm = "apple";

//   try {
//     // Create an array of promises for each scraping function with a 15-second timeout
//     const darazPromise = Promise.race([scrapeDarazProducts(searchTerm), delay(15000)]);
//     const priceoyePromise = Promise.race([scrapePriceoyeProducts(searchTerm), delay(15000)]);
//     const megaPromise = Promise.race([scrapeMegaProducts(searchTerm), delay(15000)]);
//     const myshopPromise = Promise.race([scrapeMyshopProducts(searchTerm), delay(15000)]);
//     const shophivePromise = Promise.race([scrapeShophiveProducts(searchTerm), delay(15000)]);

//     // Wait for all scraping promises to resolve using Promise.all
//     const darazProducts = await darazPromise.catch((error) => {
//       console.error('Error occurred while scraping Daraz:', error.message);
//       return []; // Return an empty array in case of error or timeout
//     });

//     const priceoyeProducts = await priceoyePromise.catch((error) => {
//       console.error('Error occurred while scraping Priceoye:', error.message);
//       return []; // Return an empty array in case of error or timeout
//     });

//     const megaProducts = await megaPromise.catch((error) => {
//       console.error('Error occurred while scraping Mega:', error.message);
//       return []; // Return an empty array in case of error or timeout
//     });

//     const myshopProducts = await myshopPromise.catch((error) => {
//       console.error('Error occurred while scraping Myshop:', error.message);
//       return []; // Return an empty array in case of error or timeout
//     });

//     const shophiveProducts = await shophivePromise.catch((error) => {
//       console.error('Error occurred while scraping Shophive:', error.message);
//       return []; // Return an empty array in case of error or timeout
//     });

//     // Combine the results from all stores into a single array
//     const allProducts = [...darazProducts, ...priceoyeProducts, ...megaProducts, ...myshopProducts, ...shophiveProducts];

//     // Return the combined product list as a response
//     console.log(allProducts);
//     console.log(allProducts.length);
//     res.send(allProducts);
//   } catch (error) {
//     console.error('Error occurred while scraping stores:', error.message);
//     res.status(500).json({ error: 'Error during scraping' });
//   }
// });

app.get('/search-for-product', authenticateToken, async (req, res) => {
  const searchTerm = req.query.searchString;
  const userID = req.user.userId;

  try {
    // Step 2: Fetch the user's favorite products from the database
    const user = await User.findOne({
      where: { user_id: userID },
      include: [{ model: Product, as: 'favoriteProductsList' }],
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

     // Filter the dummy products based on the search term
    const matchedProducts = dummy_products.filter(product =>
      product.title.toLowerCase().includes(searchTerm.toLowerCase())
    );

    // Step 3: Check if each product is favorited by the user
    const allProducts = await Promise.all(matchedProducts.map( async (product) => {
      const isFavorited = user.favoriteProductsList.some(favProduct =>
        favProduct.title === product.title && favProduct.productUrl === product.productURL
      );      
      return { ...product, isFavorite: isFavorited }; // Add isFavorite field
    }));

    // Step 4: Send back the updated list of products with isFavorite field
    //res.json(matchedProducts);
    console.log(userID);
    res.json(allProducts);
  } catch (error) {
    console.error('Error occurred while searching for products:', error);
    res.status(500).json({ error: 'Error occurred while searching for products' });
  }
});

// Function to create a promise that resolves after a given delay (timeout)
function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

app.get('/search-product', async (req, res) => {
  const searchTerm = req.query.searchString;

  try {
    // Create an array of promises for each scraping function with a 15-second timeout
    const darazPromise = Promise.race([scrapeDarazProducts(searchTerm), delay(20000)]);
    const priceoyePromise = Promise.race([scrapePriceoyeProducts(searchTerm), delay(20000)]);
     const megaPromise = Promise.race([scrapeMegaProducts(searchTerm), delay(20000)]);
     const myshopPromise = Promise.race([scrapeMyshopProducts(searchTerm), delay(20000)]);
     const shophivePromise = Promise.race([scrapeShophiveProducts(searchTerm), delay(20000)]);

    // Wait for all scraping promises to resolve using Promise.allSettled
    const settledPromises = await Promise.allSettled([
      darazPromise,
      priceoyePromise,
       megaPromise,
       myshopPromise,
       shophivePromise,
    ]);

    // Process results from completed promises
    const allProducts = [];

    settledPromises.forEach((result) => {
      if (result.status === 'fulfilled') {
        const products = result.value; // The resolved value from the scraping function
        if (Array.isArray(products)) {
          allProducts.push(...products);
        }
      } else {
        // Handle errors or timeouts for individual scraping functions
        console.error(`Error or timeout occurred: ${result.reason.message}`);
      }
    });

    // Return the combined product list as a response
    console.log(allProducts);
    console.log(allProducts.length);
    res.send(allProducts);
  } catch (error) {
    console.error('Error occurred while scraping stores:', error.message);
    res.status(500).json({ error: 'Error during scraping' });
  }
});

app.get('/get-daraz-products', async (req, res) => {
  const productURL = req.query.productURL;
  console.log("Here we go");
  const darazData = await scrapeDarazProduct(productURL);
  console.log(darazData);
  res.json(darazData);
});

// Route to get dummy data for PriceOye
app.get('/get-priceoye-products', async (req, res) => {
  const productURL = req.query.productURL;
  const priceoyeData = await scrapePriceoyeProduct(productURL);
  res.json(priceoyeData);
});

// Route to get dummy data for Mega
app.get('/get-mega-products', async (req, res) => {
  const megaData = DUMMY_STORES_DATA.mega;
  res.json(megaData);
});

// Route to get dummy data for Myshop
app.get('/get-myshop-products', async (req, res) => {
  const myshopData = DUMMY_STORES_DATA.myshop;
  res.json(myshopData);
});

// Route to get dummy data for Shophive
app.get('/get-shophive-products', async (req, res) => {
  const shophiveData = DUMMY_STORES_DATA.shophive;
  res.json(shophiveData);
});

// Function to create a promise that resolves after a given delay (timeout)
/*function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

app.get('/get-top-deals', async (req, res) => {

  try {
    // Create an array of promises for each scraping function with a 15-second timeout
    const darazPromise = Promise.race([scrapeDarazTrendingProducts(), delay(100000)]);
    const priceoyePromise = Promise.race([scrapePriceoyeTrendingProducts(), delay(100000)]);
    //const megaPromise = Promise.race([scrapeMegaProducts(), delay(15000)]);
    //const myshopPromise = Promise.race([scrapeMyshopProducts(), delay(15000)]);
    //const shophivePromise = Promise.race([scrapeShophiveProducts(), delay(15000)]);

    // Wait for all scraping promises to resolve using Promise.allSettled
    const settledPromises = await Promise.allSettled([
      darazPromise,
      priceoyePromise,
      //megaPromise,
      //myshopPromise,
      //shophivePromise,
    ]);

    // Process results from completed promises
    const allProducts = [];

    settledPromises.forEach((result) => {
      if (result.status === 'fulfilled') {
        const products = result.value; // The resolved value from the scraping function
        if (Array.isArray(products)) {
          allProducts.push(...products);
        }
      } else {
        // Handle errors or timeouts for individual scraping functions
        console.error(`Error or timeout occurred: ${result.reason.message}`);
      }
    });

    // Return the combined product list as a response
    console.log(allProducts);
    console.log(allProducts.length);
    res.send(allProducts);
  } catch (error) {
    console.error('Error occurred while scraping stores:', error.message);
    res.status(500).json({ error: 'Error during scraping' });
  }
});

// Function to create a promise that resolves after a given delay (timeout)
function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
*/

//module.exports = sequelize;

// Start the server
const port = 3000; // Choose the desired port
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

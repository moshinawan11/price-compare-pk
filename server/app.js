const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Sequelize, DataTypes } = require('sequelize');
const DUMMY_PRODUCTS = require("./products_dummy_data.js");
const dummy_products = require('./products_dummy_data2.js');
const scrapeDarazProducts = require('./scrapers/daraz.js');
const scrapePriceoyeProducts = require('./scrapers/priceoye-c.js');
const scrapeMegaProducts = require('./scrapers/mega.js');
const scrapeMyshopProducts = require('./scrapers/myshop-c.js');
const scrapeShophiveProducts = require('./scrapers/shophive-c.js');
//const scrapeDarazTrendingProducts = require('./scrapers/daraz-trending.js');
//const scrapePriceoyeTrendingProducts = require('./scrapers/priceoye-trending.js');
const scrapeDarazProduct = require('./scrapers/daraz2.js');
const scrapePriceoyeProduct = require('./scrapers/priceoye2.js');
const scrapeMegaProduct = require('./scrapers/mega3.js');
const scrapeMyshopProduct = require('./scrapers/myshop2.js');
const scrapeShophiveProduct = require('./scrapers/shophive2.js');

const app = express();
app.use(express.json());

const sequelize = new Sequelize(
  'projectdb',
  'root',
  'steyngun',
   {
     host: 'DESKTOP-NATCJ0F',
     dialect: 'mysql'
   }
 );

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
     res.json({ token, expiresIn, user_id: user.user_id, username });
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
    res.json({ token, expiresIn, user_id, username });
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
  const token = authHeader ? authHeader : null;

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

app.post('/save-product', authenticateToken, async (req, res) => {
  const { title, price, imageURL, productURL, basePrice } = req.body;

  const userID = req.user.userId;

  try {
    const user = await User.findOne({  where: { user_id: userID },
      include: [
        { model: Product, as: 'favoriteProductsList' },
        { model: Product, as: 'priceAlertProductsList'}
      ], });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const product = await Product.findOne({ where: { title, price, productURL } });

    if (!product) {
      const newProduct = await Product.create({
        title,
        price,
        imageUrl: imageURL,
        productUrl: productURL,
      });

      if (!newProduct) {
        return res.status(500).json({ error: 'Failed to save the product' });
      }

      if (!basePrice) {
        await user.addFavoriteProductsList(newProduct);
        console.log("Added new product to favorites");
      } else {
        await user.addPriceAlertProductsList(newProduct, { through: { basePrice } });
        console.log("Set price alert on new product");
      }

      return res.status(200).json({ success: true });
    } else {
      const isFavorite = await user.hasFavoriteProductsList(product);

      if (isFavorite) {
        await user.removeFavoriteProductsList(product);
        console.log("Removed product from favorites");
      } else {
        await user.addFavoriteProductsList(product);
        console.log("Added product to favorites");
      }
      const isPriceAlert = await user.hasPriceAlertProductsList(product);

      if(!isPriceAlert){
        await user.addPriceAlertProductsList(product, { through: { basePrice } });
        console.log('Successfuly set price alert on product')
      }
      return res.status(200).json({ success: true });
    }
  } catch (error) {
    console.error('Error occurred while saving the product:', error);
    return res.status(500).json({ error: 'Error occurred while saving the product' });
  }
});


app.get('/get-favorite-products', authenticateToken, async (req, res) => {
  const userID = req.user.userId;

  try {
    const user = await User.findOne({ where: { user_id: userID },
      include: [
      { model: Product, as: 'favoriteProductsList' },
      ], 
  });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const favoriteProductsList = await user.getFavoriteProductsList();

    if (favoriteProductsList.length === 0) {
      return res.status(200).json({ message: 'No favorite products found' });
    }
    return res.status(200).json(favoriteProductsList);
  } catch (error) {
    console.error('Error occurred while getting favorite products:', error);
    return res.status(500).json({ error: 'Error occurred while getting favorite products' });
  }
});

app.get('get-price-alert-products', authenticateToken, async (req, res) => {
  const userID = req.user.userId;

  try {
    const user = await User.findOne({ where: { user_id: userID },
      include: [
      { model: Product, as: 'priceAlertProductsList' },
      ], 
  });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const priceAlertProductsList = await user.getPriceAlertProductsList();

    if (priceAlertProductsList.length === 0) {
      return res.status(200).json({ message: 'No price alert products found' });
    }
    console.log(priceAlertProductsList);
    return res.status(200).json(priceAlertProductsList);
  } catch (error) {
    console.error('Error occurred while getting price alert products:', error);
    return res.status(500).json({ error: 'Error occurred while getting price alert products' });
  }
});

app.get('/search-for-product', authenticateToken, async (req, res) => {
  const searchTerm = req.query.searchString;
  const userID = req.user.userId;

  try {
    const user = await User.findOne({
      where: { user_id: userID },
      include: [{ model: Product, as: 'favoriteProductsList' }],
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const matchedProducts = dummy_products.filter(product =>
      product.title.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const allProducts = await Promise.all(matchedProducts.map( async (product) => {
      const isFavorited = user.favoriteProductsList.some(favProduct =>
        favProduct.title === product.title && favProduct.productUrl === product.productURL
      );      
      return { ...product, isFavorite: isFavorited }; 
    }));

    //res.json(matchedProducts);
    console.log(userID);
    res.json(allProducts);
  } catch (error) {
    console.error('Error occurred while searching for products:', error);
    res.status(500).json({ error: 'Error occurred while searching for products' });
  }
});

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// Search Product Route
app.get('/search-product', async (req, res) => {
  const searchTerm = req.query.searchString;

  try {
    const darazPromise = Promise.race([scrapeDarazProducts(searchTerm), delay(20000)]);
    const priceoyePromise = Promise.race([scrapePriceoyeProducts(searchTerm), delay(20000)]);
    const megaPromise = Promise.race([scrapeMegaProducts(searchTerm), delay(20000)]);
     const myshopPromise = Promise.race([scrapeMyshopProducts(searchTerm), delay(200000)]);
     const shophivePromise = Promise.race([scrapeShophiveProducts(searchTerm), delay(20000)]);

    const settledPromises = await Promise.allSettled([
      darazPromise,
      priceoyePromise,
      megaPromise,
      myshopPromise,
      shophivePromise,
    ]);

    const allProducts = [];

    settledPromises.forEach((result) => {
      if (result.status === 'fulfilled') {
        const products = result.value;
        if (Array.isArray(products)) {
          allProducts.push(...products);
        }
      } else {
        console.error(`Error or timeout occurred: ${result.reason.message}`);
      }
    });

    console.log(allProducts);
    console.log(allProducts.length);

    const filteredProducts = allProducts.filter((product) => {
      return product.title.toLowerCase().includes(searchTerm.toLowerCase());
    });

    console.log(filteredProducts);
    console.log(filteredProducts.length);
    res.send(filteredProducts);

  } catch (error) {
    console.error('Error occurred while scraping stores:', error.message);
    res.status(500).json({ error: 'Error during scraping' });
  }
});

app.get('/get-daraz-products', async (req, res) => {
  const productURL = req.query.productURL;
  const darazData = await scrapeDarazProduct(productURL);
  if (darazData.success) {
    res.json(darazData.data);
  } else {
    res.status(500).json({ error: darazData.error });
  }
});

app.get('/get-priceoye-products', async (req, res) => {
  const productURL = req.query.productURL;
  const priceoyeData = await scrapePriceoyeProduct(productURL);
  if (priceoyeData.success) {
    res.json(priceoyeData.data);
  } else {
    res.status(500).json({ error: priceoyeData.error });
  }
});

app.get('/get-mega-products', async (req, res) => {
  const productURL = req.query.productURL;
  const megaData = await scrapeMegaProduct(productURL);
  if (megaData.success) {
    res.json(megaData.data);
  } else {
    res.status(500).json({ error: megaData.error });
  }
});

app.get('/get-myshop-products', async (req, res) => {
  const productURL = req.query.productURL;
  const myshopData = await scrapeMyshopProduct(productURL);
  if (myshopData.success) {
    res.json(myshopData.data);
  } else {
    res.status(500).json({ error: myshopData.error });
  }
});

app.get('/get-shophive-products', async (req, res) => {
  const productURL = req.query.productURL;
  const shophiveData = await scrapeShophiveProduct(productURL);
  if (shophiveData.success) {
    res.json(shophiveData.data);
  } else {
    res.status(500).json({ error: shophiveData.error });
  }
});

// async function runScraper(productURL, storeName) {
//   try {
//     let productData;
//     switch (storeName) {
//       case 'daraz':
//         productData = await scrapeDarazProduct(productURL);
//         break;
//       case 'priceoye':
//         productData = await scrapePriceoyeProduct(productURL);
//         break;
//       case 'mega':
//         productData = await scrapeMegaProduct(productURL);
//         break;
//       case 'myshop':
//         productData = await scrapeMyshopProduct(productURL);
//         break;
//       case 'shophive':
//         productData = await scrapeShophiveProduct(productURL);
//         break;
//       default:
//         console.error('Invalid store name:', storeName);
//         return null;
//     }
//     return productData;
//   } catch (error) {
//     console.error(`Error scraping ${storeName} product:`, error);
//     return null;
//   }
// }

// const runPriceAlertChecks = async () => {
//   const users = await User.findAll({
//     include: [
//       { model: Product, as: 'favoriteProductsList' },
//       { model: Product, as: 'priceAlertProductsList' },
//     ],
//   });

//   for (const user of users) {
//     const priceAlertProductsList = user.priceAlertProductsList;
//     if (priceAlertProductsList.length > 0) {
//       const priceAlertProductData = [];

//       for (const priceAlertProduct of priceAlertProductsList) {
//         const productURL = priceAlertProduct.productUrl;
//         const storeName = extractStoreNameFromURL(productURL);
//         const productData = await runScraper(productURL, storeName);
//         if (productData) {
//           const currentPrice = productData.price.replace("Rs.", ""); 
//           currentPrice = currentPrice.replace(/[^\d,.]/g, ''); 
//           currentPrice = currentPrice.split('.')[0]; 
//           currentPrice = parseFloat(currentPrice);
//           const basePrice = parseFloat(priceAlertProduct.priceAlert.basePrice.replace(/[^\d.]/g, ''));
//           if (currentPrice <= basePrice) {
//             priceAlertProductData.push({
//               productData,
//               basePrice,
//             });
//           }
//         }
//       }

//       if (priceAlertProductData.length > 0) {
//         console.log(`User ${user.username} - Price alert products:`, priceAlertProductData);
//       }
//     }
//   }
// };

// function extractStoreNameFromURL(url) {
//   if (url.includes('shophive.com')) {
//     return 'shophive';
//   } else if (url.includes('daraz.pk')) {
//     return 'daraz';
//   } else if (url.includes('myshop.pk')) {
//     return 'myshop';
//   } else if (url.includes('priceoye.pk')) {
//     return 'priceoye';
//   } else if (url.includes('mega.pk')) {
//     return 'mega';
//   } else {
//     return null;
//   }
// }

// //cron.schedule('0 0 * * *', runPriceAlertChecks);

// runPriceAlertChecks();

// Start the server
const port = 3000; // Choose the desired port
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

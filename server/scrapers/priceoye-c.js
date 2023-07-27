const cheerio = require('cheerio');
const axios = require('axios');

async function scrapePriceoyeProducts(searchString) {
  try {
    const searchUrl = `https://priceoye.pk/search?q=${encodeURIComponent(searchString)}`;

    const response = await axios.get(searchUrl);
    const $ = cheerio.load(response.data);

    const productList = [];

    // Extract the product details
    $('.productBox.b-productBox').each((index, element) => {
      const fadeProductElement = $(element).find('.fadeProduct');
      if (fadeProductElement.length) {
        return; // Skip discontinued products
      }

      const nameElement = $(element).find('.p-title.bold.h5');
      const name = nameElement.text().trim();

      const priceElement = $(element).find('.price-box.p1');
      const price = priceElement.text().trim();

      const imageElement = $(element).find('.image-box.desktop amp-img');
      const image = imageElement.attr('src');

      const urlElement = $(element).find('.productBox.b-productBox a');
      const productUrl = urlElement.attr('href');

      if (!name || !price || !image || !productUrl) {
        return; // Skip this iteration
      }

      const productObj = {
        title: name,
        price: price,
        imageURL: image,
        productURL: productUrl
      };

      productList.push(productObj);
    });

    console.log(productList);
    console.log(productList.length);
    
    return productList;

  } catch (error) {
    console.error('Error occurred while scraping Priceoye:', error.message);
    throw error;
  }
}

module.exports = scrapePriceoyeProducts;

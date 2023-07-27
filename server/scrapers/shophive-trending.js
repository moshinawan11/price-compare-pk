const cheerio = require('cheerio');
const axios = require('axios');

async function scrapeShophiveTrendingProducts() {
  try {
    const searchUrl = 'https://www.shophive.com/';

    const response = await axios.get(searchUrl/*, { timeout: 15000 }*/);
    const $ = cheerio.load(response.data);

    const productList = [];

    // Extract the product details
    $('.item-list-content > a').each((index, element) => {

      const nameElement = $(element).find('.sale-title');
      const name = nameElement.text().trim();

      const salePriceElement = $(element).find('.sale-price');
      const salePrice = salePriceElement.text().trim();

      const originPriceElement = $(element).find('.origin-price-value');
      const originPrice = originPriceElement.text().trim();

      const discountElement = $(element).find('.origin-price-value');
      const discount = discountElement.text().trim();

      const imageElement = $(element).find('.image');
      const image = imageElement.attr('src');

      const urlElement = $(element).attr('href'); 
      const productUrl = urlElement.trim();

      if (!name || !salePrice || !image || !productUrl) {
        return; // Skip this iteration
      }

      const productObj = {
        title: name,
        salePrice: salePrice,
        originPrice: originPrice,
        discount: discount,
        imageURL: image,
        productURL: productUrl
      };

      productList.push(productObj);
    });

    console.log(productList);
    console.log(productList.length);
    
    return productList;

  } catch (error) {
    console.error('Error occurred while scraping Daraz:', error.message);
    throw error;
  }
}

scrapeShophiveTrendingProducts();
//module.exports = scrapeShophiveTrendingProducts;

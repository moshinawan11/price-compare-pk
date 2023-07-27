const cheerio = require('cheerio');
const axios = require('axios');

async function scrapeShophiveProducts(searchString) {
  try {
    const searchUrl = `https://www.shophive.com/catalogsearch/result/?q=${encodeURIComponent(searchString)}`;

    const response = await axios.get(searchUrl);
    const $ = cheerio.load(response.data);

    const productList = [];

    // Extract the product details
    $('.item.product.product-item.tp-6-col.col-xl-3.col-lg-4.col-md-4.col-sm-6.col-6').each((index, element) => {
      const nameElement = $(element).find('.product.name.product-item-name .product-item-link');
      const name = nameElement.text().trim();

      const priceElement = $(element).find('.price-wrapper .price');
      const price = priceElement.text().trim();

      const imageElement = $(element).find('.product-image-photo');
      const image = imageElement.attr('src');

      const urlElement = $(element).find('.product.name.product-item-name .product-item-link');
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
    console.error('Error occurred while scraping Shophive:', error.message);
    throw error;
  }
}

module.exports = scrapeShophiveProducts;
const cheerio = require('cheerio');
const axios = require('axios');

async function scrapeMyshopProducts(searchString) {
  try {
    const baseUrl = 'https://myshop.pk/catalogsearch/result/?';
    const queryParams = {
      q: encodeURIComponent(searchString),
    };
    const searchUrl = `${baseUrl}${new URLSearchParams(queryParams).toString()}`;

    // Fetch the page HTML using axios
    const response = await axios.get(searchUrl);
    const html = response.data;

    // Load the HTML into Cheerio
    const $ = cheerio.load(html);

    const productList = [];

    // Extract the product details using Cheerio
    $('.filterproducts.products.list.items.product-items li').each((index, element) => {
      const nameElement = $(element).find('.product-item-link');
      let name = nameElement.text().trim();

      const priceElement = $(element).find('.price');
      let price = priceElement.text().trim();

      const imageElement = $(element).find('.product-image-photo.hover_image');
      let image = imageElement.attr('src');

      const urlElement = $(element).find('.product-item-link');
      let productUrl = urlElement.attr('href');

      if (!name || !price || !image || !productUrl) {
        return; // Skip this iteration
      }

      name = name.replace(/\n/g, '').replace(/\t/g, '');
      price = price.replace(/\n/g, '').replace(/\t/g, '');

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
    console.error('Error occurred while scraping Myshop:', error.message);
    throw error;
  }
}

// Example usage:
module.exports = scrapeMyshopProducts;

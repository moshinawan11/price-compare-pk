const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeMegaProducts(productURL) {
  try {
    // Fetch the HTML content of the page
    const response = await axios.get(`${productURL}`);
    const htmlContent = response.data;

    // Use Cheerio to load and parse the HTML
    const $ = cheerio.load(htmlContent);

    // Extract the required data using Cheerio selectors
    const image = $('#main-prod-img').attr('src');
    const title = $('.product-title').text().trim();
    const price = $('#price').text().trim();

    const brandElement = $('.blue-cat-link.blue-link span meta');
    const brand = brandElement.attr('content');

    const productSpecsMap = new Map();

    let currentTh; // Variable to keep track of the current th element

    $('#laptop_detail tr').each((index, row) => {
      const thElement = $(row).find('th');
      const tdElements = $(row).find('td');
      
      if (thElement.length) {
        currentTh = thElement.text().trim();
        productSpecsMap.set(currentTh, new Map());
      } else if (currentTh && tdElements.length === 2) {
        const tdLabel = $(tdElements[0]).text().trim();
        const tdData = $(tdElements[1]).text().trim();
        productSpecsMap.get(currentTh).set(tdLabel, tdData);
      }
    });
    
    if(image && price && image){
      const productData = {
        title: title,
        price: price,
        image: image,
        brand: brand,
        productSpecs: Array.from(productSpecsMap.entries()).reduce((obj, [key, value]) => {
          obj[key] = Object.fromEntries(value);
          return obj;
        }, {})
      };
      console.log(productData);
      return { success: true, data: productData };
    }
  } catch (error) {
    console.log("Error occured", error);
    return { success: false, error: error.message };
  }
}

module.exports = scrapeMegaProducts;

const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeShophiveProducts() {
  try {
    // Fetch the HTML content of the page
    const response = await axios.get('https://www.shophive.com/d-link-ncbc6ugry305-23awg-cat-6-utp-cable-roll-1000ft/');
    const htmlContent = response.data;

    // Use Cheerio to load and parse the HTML
    const $ = cheerio.load(htmlContent);

    // Extract the required data using Cheerio selectors
    const title = $('.page-title span').text().trim();
    const price = $('.price-wrapper span').text().trim();
    const image = $('.fotorama__img.magnify-opaque').attr('src');

    console.log("Title: ", title);
    console.log("Price: ", price);
    console.log("Image: ", image);

    const brand = $('.brand-link').attr('title');
    const availability = $('.stock.available').text().trim();

    const productDetailsElement = $('.product.attribute.description .value');
    const productDetailsList = traverseDOM(productDetailsElement, $);

    const productSpecsMap = new Map();

    $('#product-attribute-specs-table tbody tr').each((index, productSpecs) => {
      const label = $(productSpecs).find('.label').text().trim();
      const data = $(productSpecs).find('.data').text().trim();
      productSpecsMap.set(label, data);
    });

    console.log("Brand: ", brand);
    console.log("Availability: ", availability);
    if (productDetailsList.length > 0)
      console.log("Product Details: ", productDetailsList);
    console.log("Product Specs: ", productSpecsMap);
  } catch (error) {
    console.error("Error occurred:", error);
  }
}

function traverseDOM(element, $) {
  const productDetailsInitial = [];
  
  element.contents().each((index, childNode) => {
    if (childNode.nodeType === 3) {
      // Text node
      productDetailsInitial.push($(childNode).text().trim());
    } else if (childNode.nodeType === 1) {
      // Element node
      productDetailsInitial.push($(childNode).text().trim());
    }
  });

  const productDetailsCleaned = productDetailsInitial
    .filter(detail => detail.trim() !== '') 
    .map(detail => detail.replace(/\n/g, ' ')); 
  
  return productDetailsCleaned;
}

scrapeShophiveProducts();
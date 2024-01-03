const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeShophiveProducts(productURL) {
  try {
    const response = await axios.get(productURL);
    const htmlContent = response.data;
    const $ = cheerio.load(htmlContent);

    const title = $('.page-title span').text().trim();
    const price = $('.price-wrapper span').text().trim();
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

    productData = {
      title,
      price,
      brand,
      availability,
      productDetailsList,
      productSpecs: Object.fromEntries(productSpecsMap),
    };

    console.log(productData);
    return { success: true, data: productData }
  } catch (error) {
    console.error("Error occurred:", error);
    return { error: error.message };
  }
}

function traverseDOM(element, $) {
  const productDetailsInitial = [];

  element.contents().each((index, childNode) => {
    if (childNode.nodeType === 3) {
      productDetailsInitial.push($(childNode).text().trim());
    } else if (childNode.nodeType === 1) {
      productDetailsInitial.push($(childNode).text().trim());
    }
  });

  const productDetailsCleaned = productDetailsInitial
    .filter(detail => detail.trim() !== '')
    .map(detail => detail.replace(/\n/g, ' '));

  return productDetailsCleaned;
}

module.exports = scrapeShophiveProducts;


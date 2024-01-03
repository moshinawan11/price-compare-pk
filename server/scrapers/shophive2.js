const puppeteer = require('puppeteer');

async function scrapeShophiveProducts(productURL) {
  const browser = await puppeteer.launch();
  
  let productData = {};

  try {
    const page = await browser.newPage();

    await page.setDefaultNavigationTimeout(0);

    await page.goto(`${productURL}`);

    const titleElement = await page.$('.page-title span');
    productData.title = await page.evaluate(element => element.textContent, titleElement);

    const priceElement = await page.$('.price-wrapper span');
    productData.price = await page.evaluate(element => element.textContent, priceElement);

    await page.waitForSelector('#magnifier-item-0');
    const imageElement = await page.$('#magnifier-item-0');
    productData.image = await page.evaluate(element => element.getAttribute('src'), imageElement);

    const brandElement = await page.$('.brand-link');
    productData.brand = await page.evaluate(element => element.getAttribute('title'), brandElement);

    const availabilityElement = await page.$('.stock.available');
    productData.availability = await page.evaluate(element => element.textContent, availabilityElement);

    const productDetailsElement = await page.$('.product.attribute.description .value');
    productData.productDetails = await page.evaluate(element => {
      const productDetailsInitial = [];
      
      for (const childNode of element.childNodes) {
        if (childNode.nodeType === Node.TEXT_NODE) {
            productDetailsInitial.push(childNode.textContent.trim());
        } else if (childNode.nodeType === Node.ELEMENT_NODE) {
            productDetailsInitial.push(childNode.innerText.trim());
        }
      }
  
      const productDetailsCleaned = productDetailsInitial
        .filter(detail => detail.trim() !== '') 
        .map(detail => detail.replace(/\n/g, ' ')); 
      
      return productDetailsCleaned;
    }, productDetailsElement);

    const productSpecsMap = new Map();

    const productSpecsElements = await page.$$('#product-attribute-specs-table tbody tr');

    for(const productSpecs of productSpecsElements){
      const labelElement = await productSpecs.$('.label');
      const label = await page.evaluate(element => element.textContent, labelElement);

      const dataElement = await productSpecs.$('.data');
      const data = await page.evaluate(element => element.textContent, dataElement);

      productSpecsMap.set(label, data);
    }

    productData.productSpecs = Object.fromEntries(productSpecsMap);

    console.log("Product Data: ", productData);

    return { success: true, data: productData };
  } catch(error) {
    console.log("Error occurred while scraping data", error);
    return { success: false, error: error.message };
  } finally {
    await browser.close();
  }
}

module.exports = scrapeShophiveProducts;

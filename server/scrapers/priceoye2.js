const puppeteer = require('puppeteer');

async function scrapePriceoyeProducts(productURL) {
  const browser = await puppeteer.launch();
  let productData = {};

  try {
    const page = await browser.newPage();

    await page.setDefaultNavigationTimeout(0);

    // Navigate to the website
    await page.goto(`${productURL}`);

    const titleElement = await page.$('.product-title h3');
    productData.title = await page.evaluate(element => element.textContent, titleElement);

    const priceElement = await page.$('.summary-price.text-black.price-size-lg.bold');
    productData.price = priceElement ? await page.evaluate(element => element.textContent, priceElement) : undefined;

    const imageElement = await page.$('img.main-product-img');
    productData.image = await page.evaluate(element => element.getAttribute('src'), imageElement);

    const availabilityElement = await page.$('.summary-price.text-black.bold.stock-status');
    productData.availability = availabilityElement ? await page.evaluate(element => element.textContent, availabilityElement) : undefined;

    const ratingElement = await page.$('.semi-bold.rating-points');
    productData.rating = ratingElement ? await page.evaluate(element => element.textContent, ratingElement) : undefined;

    productData.colors = [];
    const colorsElements = await page.$$('.colors li');
    if (colorsElements) {
      for (const colorsElement of colorsElements) {
        const colorText = await colorsElement.$('.color-name span');
        const color = await colorsElement.evaluate(element => element.textContent, colorText);
        productData.colors.push(color);
      }
    }

    // Select and parse the product specifications
    productData.specifications = {};
    const specsTables = await page.$$('.column.column-80 table.p-spec-table');

    for (const table of specsTables) {
      const headerElement = await table.$('th[colspan="2"]');
      const header = await page.evaluate(element => element.textContent, headerElement);
      const rows = await table.$$('tbody tr');

      productData.specifications[header] = {};

      for (const row of rows) {
        const thElement = await row.$('th');
        const tdElement = await row.$('td');

        const attribute = await page.evaluate(element => element.textContent.trim(), thElement);
        const value = await page.evaluate(element => element.textContent.trim(), tdElement);

        productData.specifications[header][attribute] = value;
      }
    }

    console.log("Product Data: ", productData);
    return productData;
    
  } catch (error) {
    console.log("Error occurred while parsing data", error);
    throw error;
  } finally {
    await browser.close();
  }
}

module.exports = scrapePriceoyeProducts;

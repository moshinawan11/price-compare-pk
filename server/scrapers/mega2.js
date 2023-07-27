const puppeteer = require('puppeteer');

async function scrapeMegaProducts() {
  const browser = await puppeteer.launch({
    headless: false
  });
  const page = await browser.newPage();

  await page.setDefaultNavigationTimeout(0);

  // Navigate to the website
  await page.goto('https://www.mega.pk/airconditioners_products/22350/Gree-Gs-12fith3w-10-Ton-Heat---Cool-Inverter-Wall-Mount-WiFi.html');

  const imageElement = await page.$('#main-prod-img');
  const image = await page.evaluate(element => element.getAttribute('src'), imageElement);

  const titleElement = await page.$('.product-title');
  const title = await page.evaluate(element => element.textContent, titleElement);

  const priceElement = await page.$('#price');
  const price = await page.evaluate(element => element.textContent, priceElement);

  console.log("Title: ", title);
  console.log("Price: ", price);
  console.log("Image: ", image);

  const brandElement = await page.$('.blue-cat-link.blue-link span meta');
  const brand = await page.evaluate(element => element.getAttribute('content'), brandElement);

  const productSpecsTable = await page.$('#laptop_detail');
  const productSpecsRows = await productSpecsTable.$$('tr');

  const productSpecsMap = new Map();

  let currentTh; // Variable to keep track of the current th element

  for (const row of productSpecsRows) {
    const thElement = await row.$('th');
    const tdElements = await row.$$('td');
      
    if (thElement) {
        currentTh = await page.evaluate(element => element.innerText.trim(), thElement);
        productSpecsMap.set(currentTh, new Map());
    } else if (currentTh && tdElements.length === 2) {
        const tdLabelElement = tdElements[0];
        const tdLabel = await page.evaluate(element => element.innerText.trim(), tdLabelElement);

        const tdDataElement = tdElements[1];
        const tdData = await page.evaluate(element => element.innerText.trim(), tdDataElement);

        productSpecsMap.get(currentTh).set(tdLabel, tdData);
    }
}

  console.log("Brand: ", brand);
  console.log("Product Specs: ", productSpecsMap);

  // Close the browser
  await browser.close();
}

scrapeMegaProducts();
const puppeteer = require('puppeteer');

async function scrapeMegaProducts(searchString) {
  const browser = await puppeteer.launch({
    headless: false
  });
  try{
    const page = await browser.newPage();

    await page.setDefaultNavigationTimeout(20000);

    // Navigate to the website
    await page.goto('https://www.mega.pk/');

    // Type "iphone" in the search input
    await page.type('input[name="searchq"]', `${searchString}`);

    // Press Enter to perform the search
    await page.keyboard.press('Enter');

    page.waitForNavigation(), 

    // Wait for the products to load
    await page.waitForSelector('.item_grid.list-inline.clearfix');

    // Extract the product details
    const products = await page.$$('.col-xs-6.col-sm-4.col-md-4.col-lg-3');

    const productList = [];

    for (const product of products) {
      const nameElement = await product.$('#lap_name_div > h3 > a');
      let name = nameElement ? await page.evaluate(element => element.textContent, nameElement) : undefined ;

      const priceElement = await product.$('.cat_price');
      let price = priceElement ? await page.evaluate(element => element.textContent, priceElement) : undefined ;

      const urlElement = await product.$('#lap_name_div > h3 > a');
      const productUrl = urlElement ? await page.evaluate(element => element.getAttribute('href'), urlElement) : undefined ;

      const imageElement = await product.$('.image > .wrapper1 > a > .tt');
      
      // Wait for the image to load
      await page.waitForFunction(
        element => element.complete && element.naturalHeight !== 0,
        {},
        imageElement
      );
      
      const image = imageElement ? await page.evaluate(element => element.getAttribute('data-original') || element.getAttribute('src'), imageElement) : undefined;

      if (!name || !price || !image || !productUrl) {
        continue;
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
      }
    
      console.log(productList);
      console.log(productList.length);

      return productList;
      
  } catch(error){
    console.error('Error occurred while scraping Mega:', error.message);
    throw error;
  } finally {
    await browser.close();
  }
}

//scrapeMegaProducts('apple');
module.exports = scrapeMegaProducts;
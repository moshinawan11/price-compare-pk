const puppeteer = require('puppeteer');

async function scrapeDarazProducts(searchString) {
  const browser = await puppeteer.launch();
  try{
    const baseUrl = 'https://www.daraz.pk/catalog/?';
    const queryParams = {
      q: encodeURIComponent(searchString),
    };
    const searchUrl = `${baseUrl}${new URLSearchParams(queryParams).toString()}`;

    const page = await browser.newPage();

    await page.setDefaultNavigationTimeout(20000);

    // Navigate to the website
    await page.goto(searchUrl);

    // Wait for the products to load
    await page.waitForSelector('.box--ujueT');

    // Extract the product details
    const products = await page.$$('.box--ujueT .gridItem--Yd0sa');

    const productList = [];

    for (const product of products) {
      const nameElement = await product.$('.title--wFj93 a');
      let name = nameElement ? await page.evaluate(element => element.textContent, nameElement) : undefined ;

      const priceElement = await product.$('.price--NVB62 span');
      let price = priceElement ? await page.evaluate(element => element.textContent, priceElement) : undefined;

      const imageElement = await product.$('.image--WOyuZ');
      let image = imageElement ? await page.evaluate(element => element.getAttribute('src'), imageElement) : undefined;

      const urlElement = await product.$('.title--wFj93 a');
      let productUrl = urlElement ? await page.evaluate(element => element.getAttribute('href'), urlElement) : undefined;

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
      console.log('Error occurred while scraping Daraz:', error.message);
    } finally {
      await browser.close();
    }
}

module.exports = scrapeDarazProducts;
//scrapeDarazProducts("iphone");
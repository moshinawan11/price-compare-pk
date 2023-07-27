const puppeteer = require('puppeteer');

async function scrapePriceoyeTrendingProducts() {
  const browser = await puppeteer.launch();
  try {
    const searchUrl = 'https://priceoye.pk/';

    const page = await browser.newPage();

    await page.setDefaultNavigationTimeout(0);

    // Navigate to the website
    await page.goto(searchUrl);

    await page.waitForSelector('.product-grid');

    const products = await page.$$('.product-grid > div');
    const productList = [];

    for (const product of products) {

        const nameElement = await product.$('.p3.product-name') || await product.$('.p4.product-name');
        let name = nameElement ? await page.evaluate(element => element.textContent, nameElement) : undefined ;

        const salePriceElement = await product.$('.price-box');
        let salePrice = salePriceElement ? await page.evaluate(element => element.textContent, salePriceElement) : undefined ;

        const originPriceElement = await product.$('.price-diff-retail');
        let originPrice = originPriceElement ? await page.evaluate(element => element.textContent, originPriceElement) : undefined ;

        const discountElement = await product.$('.price-diff-saving');
        let discount = discountElement ? await page.evaluate(element => element.textContent, discountElement) : undefined ;

        const imageElement = await product.$('.i-amphtml-fill-content.i-amphtml-replaced-content');
        let image = imageElement ? await page.evaluate(element => element.getAttribute('src'), imageElement) : undefined;

        const urlElement = await product.$('a');
        let productUrl = urlElement ? await page.evaluate(element => element.getAttribute('href'), urlElement) : undefined ;

        if (!name || !salePrice || !image || !productUrl) {
            continue;
          }
    
          name = name.replace(/\n/g, '').replace(/\t/g, '');
          salePrice = salePrice.replace(/\n/g, '').replace(/\t/g, '');
          originPrice = salePrice.replace(/\n/g, '').replace(/\t/g, '');
          discountPrice = salePrice.replace(/\n/g, '').replace(/\t/g, '');

        const productObj = {
          title: name,
          salePrice: salePrice,
          originPrice: originPrice,
          discount: discount,
          imageURL: image,
          productURL: productUrl
        };

        productList.push(productObj);
    }

    console.log(productList);
    console.log(productList.length);

    return productList;

  } catch (error) {
    console.error('Error occurred while scraping Priceoye:', error.message);
    throw error;
  } finally {
    // Close the browser when done
    await browser.close();
  }
}

module.exports = scrapePriceoyeTrendingProducts;

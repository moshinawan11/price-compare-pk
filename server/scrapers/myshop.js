const puppeteer = require('puppeteer');

async function scrapeMyshopProducts(searchString) {
  const browser = await puppeteer.launch();
  try {
    const baseUrl = 'https://myshop.pk/catalogsearch/result/?';
    const queryParams = {
      q: encodeURIComponent(searchString),
    };
    const searchUrl = `${baseUrl}${new URLSearchParams(queryParams).toString()}`;

    const page = await browser.newPage();

    await page.setDefaultNavigationTimeout(0);

    // Navigate to the website
    await page.goto(`${searchUrl}`);

    // Wait for the products to load
    await page.waitForSelector('.product-image-photo.default_image');

    // Wait for the network to be idle
    await page.waitForLoadState('networkidle');

    // Extract the product details
    const products = await page.$$('.filterproducts.products.list.items.product-items li');

    const productList = [];

    for (const product of products) {
      const nameElement = await product.$('.product-item-link');
      let name = nameElement ? await page.evaluate(element => element.textContent.trim(), nameElement) : undefined;

      const priceElement = await product.$('.price');
      let price = priceElement ? await page.evaluate(element => element.textContent.trim(), priceElement) : undefined;

      const urlElement = await product.$('.product-item-link');
      let productUrl = urlElement ? await page.evaluate(element => element.getAttribute('href'), urlElement) : undefined;

      const imageElement = await product.$('.product-image-photo.default_image');

      // Wait for the image to load
      await imageElement?.evaluate(element => {
        return new Promise(resolve => {
          if (element.complete && element.naturalHeight !== 0) {
            resolve();
          } else {
            element.addEventListener('load', () => resolve());
          }
        });
      });

      const image = imageElement ? await page.evaluate(element => element.getAttribute('src'), imageElement) : undefined;

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

  } catch (error) {
    console.error('Error occurred while scraping Myshop:', error.message);
  } finally {
    await browser.close();
  }
}

module.exports = scrapeMyshopProducts;

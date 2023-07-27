const puppeteer = require('puppeteer');

async function scrapeDarazTrendingProducts() {
  const browser = await puppeteer.launch();
  try {
    const searchUrl = 'https://www.daraz.pk/wow/i/pk/landingpage/flash-sale?spm=a2a0e.home.flashSale.1.35e34076NhjI7s&wh_weex=true&amp;wx_navbar_transparent=true&amp;scm=1003.4.icms-zebra-5029921-2824236.OTHER_5360388823_2475751&skuIds=418398083,390170026,390464595,372869128,348169836,270768888,231032153';

    const page = await browser.newPage();

    await page.setDefaultNavigationTimeout(0);

    // Navigate to the website
    await page.goto(searchUrl);

    // Function to scroll the page to the bottom to load more products
    async function autoScroll() {
      await page.evaluate(async () => {
        await new Promise((resolve) => {
          let totalHeight = 0;
          const distance = 500;
          const timer = setInterval(() => {
            const scrollHeight = document.body.scrollHeight;
            window.scrollBy(0, distance);
            totalHeight += distance;

            if (totalHeight >= scrollHeight) {
              clearInterval(timer);
              resolve();
            }
          }, 100);
        });
      });
    }

    // Scroll the page multiple times to load more products
    await autoScroll();
    // Add more scrolls if necessary based on the number of products in the page

    await page.waitForSelector('.item-list-content');

    const productList = await page.evaluate(() => {
      const items = document.querySelectorAll('.item-list-content > a');
      const productList = [];

      items.forEach((item) => {
        const nameElement = item.querySelector('.sale-title');
        const name = nameElement ? nameElement.textContent.trim() : '';

        const salePriceElement = item.querySelector('.sale-price');
        const salePrice = salePriceElement ? salePriceElement.textContent.trim() : '';

        const originPriceElement = item.querySelector('.origin-price-value');
        const originPrice = originPriceElement ? originPriceElement.textContent.trim() : '';

        const discountElement = item.querySelector('.discount');
        const discount = discountElement ? discountElement.textContent.trim() : '';

        const imageElement = item.querySelector('.image');
        const image = imageElement ? imageElement.getAttribute('src') : '';

        const urlElement = item.getAttribute('href'); 
        const productUrl = urlElement ? urlElement.trim() : '';

        if (!name || !salePrice || !image || !productUrl) {
          return; // Skip this iteration
        }

        const productObj = {
          title: name,
          salePrice: salePrice,
          originPrice: originPrice,
          discount: discount,
          imageURL: image,
          productURL: productUrl
        };

        productList.push(productObj);
      });

      return productList;
    });

    console.log(productList);
    console.log(productList.length);
    
    return productList;

  } catch (error) {
    console.error('Error occurred while scraping Daraz:', error.message);
    throw error;
  } finally {
    // Close the browser when done
    await browser.close();
  }
}

module.exports = scrapeDarazTrendingProducts;

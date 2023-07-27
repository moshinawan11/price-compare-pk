const cheerio = require('cheerio');
const axios = require('axios');

async function scrapeDarazProducts() {
  try {
    const searchQuery = 'apple';
    const baseUrl = 'https://www.daraz.pk/catalog/?';
    const queryParams = {
      q: encodeURIComponent(searchQuery),
    };
    const searchUrl = `${baseUrl}${new URLSearchParams(queryParams).toString()}`;

    const headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.1234.567 Safari/537.36',
    };

    // Fetch the page HTML using axios
    const response = await new Promise((resolve) => {
      setTimeout(async () => {
        const response = await axios.get(searchUrl, { headers });
        resolve(response);
      }, 10000); // Change the delay time (in milliseconds) as needed
    });

    const html = response.data;
    
    // Load the HTML into Cheerio
    const $ = cheerio.load(html);

    const productList = [];

    // Extract the product details
    $('.box--ujueT .gridItem--Yd0sa').each((index, element) => {
      const nameElement = $(element).find('.title--wFj93 a');
      const name = nameElement.text().trim();

      const priceElement = $(element).find('.price--NVB62 span');
      const price = priceElement.text().trim();

      const imageElement = $(element).find('.image--WOyuZ');
      const image = imageElement.attr('src');

      const urlElement = $(element).find('.title--wFj93 a');
      const productUrl = urlElement.attr('href');

      if (!name || !price || !image || !productUrl) {
        return; // Skip this iteration
      }

      const productObj = {
        title: name,
        price: price,
        imageURL: image,
        productURL: productUrl
      };

      productList.push(productObj);
    });

    console.log(productList);
    console.log(productList.length);
  } catch (error) {
    console.error('Error occurred while scraping Daraz:', error.message);
  }
}

// Example usage:
scrapeDarazProducts();

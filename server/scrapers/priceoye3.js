const axios = require('axios');
const cheerio = require('cheerio');

async function scrapePriceoyeProducts(productURL) {
  try {
    // Fetch the HTML content of the page
    const response = await axios.get(productURL);
    const htmlContent = response.data;

    const $ = cheerio.load(htmlContent);

    const title = $('.product-title h3').text().trim();

    const priceElement = $('.summary-price.text-black.price-size-lg.bold');
    const price = priceElement.length ? priceElement.text().trim() : undefined;

    const availabilityElement = $('.summary-price.text-black.bold.stock-status');
    const availability = availabilityElement.length ? availabilityElement.text().trim() : undefined;

    const ratingElement = $('.semi-bold.rating-points');
    const rating = ratingElement.length ? ratingElement.text().trim() : undefined;

    const colors = [];
    $('.colors li').each((index, element) => {
      const colorText = $(element).find('.color-name span').text().trim();
      colors.push(colorText);
    });

    const specifications = {};

    $('.column.column-80 table.p-spec-table').each((index, table) => {
      const header = $(table).find('th[colspan="2"]').text().trim();
      specifications[header] = {};

      $(table).find('tbody tr').each((index, row) => {
        const attribute = $(row).find('th').text().trim();
        const value = $(row).find('td').text().trim();
        specifications[header][attribute] = value;
      });
    });

    const productData = {
      title: title,
      price: price,
      availability: availability,
      rating: rating,
      colors: colors,
      specifications: specifications
    };

    console.log(productData);
    return productData;

    return { success: true, data: productData };
  } catch (error) {
    return { error: error.message };
  }
}

module.exports = scrapePriceoyeProducts;

const axios = require('axios');
const cheerio = require('cheerio');

async function scrapePriceoyeProducts() {
  const url = 'https://priceoye.pk/smart-watches/dany/dany-rex-fit-smart-watch';

  try {
    // Fetch the HTML content of the page
    const response = await axios.get(url);
    const htmlContent = response.data;

    // Use Cheerio to load and parse the HTML
    const $ = cheerio.load(htmlContent);

    // Extract the product details
    const title = $('.product-title h3').text().trim();

    const priceElement = $('.summary-price.text-black.price-size-lg.bold');
    const price = priceElement.length ? priceElement.text().trim() : undefined;

    const image = $('img.main-product-img').attr('src');

    console.log("Title: ", title);
    if (price)
      console.log("Price: ", price);
    console.log("Image: ", image);

    const availabilityElement = $('.summary-price.text-black.bold.stock-status');
    const availability = availabilityElement.length ? availabilityElement.text().trim() : undefined;

    const ratingElement = $('.semi-bold.rating-points');
    const rating = ratingElement.length ? ratingElement.text().trim() : undefined;

    const colors = [];
    $('.colors li').each((index, element) => {
      const colorText = $(element).find('.color-name span').text().trim();
      colors.push(colorText);
    });

    if (rating)
      console.log("Rating: ", rating);
    if (availability)
      console.log("Availability: ", availability);
    if (colors.length !== 0)
      console.log("Available Colors: ", colors);

    // Select and parse the product specifications
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

    console.log("Specifications: ", specifications);

    // Format data into JSON object to be sent to the server
    const productData = {
      title: title,
      price: price,
      image: image,
      availability: availability,
      rating: rating,
      colors: colors,
      specifications: specifications
    };

  } catch (error) {
    console.error("Error occurred:", error);
    throw error;
  }
}

scrapePriceoyeProducts();

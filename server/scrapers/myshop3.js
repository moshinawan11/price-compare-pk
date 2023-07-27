const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeMyshopProducts() {
  const url = 'https://myshop.pk/apple-macbook-air-2020-13-m1-chip-256gb-with-touch-id-s-pakistan.html';

  try {
    // Fetch the HTML content of the product page
    const response = await axios.get(url);
    const htmlContent = response.data;

    // Use Cheerio to load and parse the HTML
    const $ = cheerio.load(htmlContent);

    // Extract the product details using Cheerio selectors
    const title = $('.page-title span').text().trim();
    const price = $('.price').text().trim();
    const image = $('.fotorama__active .fotorama__img').attr('src');

    console.log("Title: ", title);
    console.log("Price: ", price);
    console.log("Image: ", image);

    // Function to parse table data and return an organized structure
    function parseTableData() {
      const tableData = {};

      // Find the table rows inside the tbody
      $('.data.table.additional-attributes tbody tr').each((index, row) => {
        const thElement = $(row).find('th');
        const tdElement = $(row).find('td');

        if (thElement.length && tdElement.length) {
          // Extract the label and data values from th and td elements
          const label = thElement.text().trim();
          const dataElements = tdElement.find('br').length ? tdElement.find('br').prevAll() : tdElement;
          const data = extractData(dataElements);

          // Check if the label is not "Detail" and the data has only one line
          if (label !== 'Detail' && label !== 'Other Detail' && data.length === 1) {
            // Handle multiple details for a single label
            if (tableData[label]) {
              if (Array.isArray(tableData[label])) {
                tableData[label].push(data[0]);
              } else {
                tableData[label] = [tableData[label], data[0]];
              }
            } else {
              tableData[label] = data[0];
            }
          }
        }
      });

      return tableData;
    }

    // Function to extract data from Cheerio elements
    function extractData(dataElements) {
      const extractedData = [];

      dataElements.each((index, element) => {
        const nodeValue = $(element).contents().filter((_, node) => node.nodeType === 3).text().trim();

        if (nodeValue) {
          extractedData.push(nodeValue);
        }
      });

      return extractedData;
    }

    // Call the function to get the parsed table data
    const parsedTableData = parseTableData();

    console.log("Parsed Table Data: ", parsedTableData);

  } catch (error) {
    console.error("Error occurred:", error);
  }
}

scrapeMyshopProducts();

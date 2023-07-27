/*const cheerio = require('cheerio');
const axios = require('axios');

async function scrapeMyshopProducts() {
  // Fetch the HTML content of the product page using axios
  const response = await axios.get('https://myshop.pk/hp-678-black-ink-cartridge-pakistan.html');
  const htmlData = response.data;

  // Load the HTML data into Cheerio
  const $ = cheerio.load(htmlData);

  // Extract the product details
  const titleElement = $('.page-title span');
  const title = titleElement.text().trim();

  const priceElement = $('.price');
  const price = priceElement.text().trim();

  const imageElement = $('.fotorama__active .fotorama__img');
  const image = imageElement.attr('src');

  console.log("Title: ", title);
  console.log("Price: ", price);
  console.log("Image: ", image);

  //console.log("Image: ", image);

  // Function to parse table data and return an organized structure
  function parseTableData() {
    const tableData = {};

    // Find the table rows inside the tbody
    $('.data.table.additional-attributes tbody tr').each((index, element) => {
      const thElement = $(element).find('th');
      const tdElement = $(element).find('td');

      if (thElement.length && tdElement.length) {
        // Extract the label and data values from th and td elements
        const label = thElement.text().trim();
        const dataElement = tdElement.find('br').length ? tdElement.contents().toArray() : [tdElement];
        const data = extractData(dataElement);

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

  // Function to extract data from cheerio elements
  function extractData(dataElement) {
    const extractedData = [];

    dataElement.forEach((element) => {
      const nodeType = element.nodeType;
      const nodeValue = nodeType === 3 ? element.nodeValue.trim() : $(element).text().trim();

      if (nodeValue) {
        extractedData.push(nodeValue);
      }
    });

    return extractedData;
  }

  // Call the function to get the parsed table data
  const parsedTableData = parseTableData();

  console.log(parsedTableData);

}

scrapeMyshopProducts();
*/


const puppeteer = require('puppeteer');

async function scrapeMyshopProducts() {
  const url = 'https://myshop.pk/apple-macbook-air-2020-13-m1-chip-256gb-with-touch-id-s-pakistan.html';

  // Launch a headless browser using Puppeteer
  const browser = await puppeteer.launch();
  try{
  const page = await browser.newPage();

  await page.setDefaultNavigationTimeout(0);

  // Navigate to the product page
  await page.goto(url);

  // Extract the product details using Puppeteer
  const titleElement = await page.$('.page-title span');
  const title = await page.evaluate(element => element.textContent.trim(), titleElement);

  const priceElement = await page.$('.price');
  const price = await page.evaluate(element => element.textContent.trim(), priceElement);

  const imageElement = await page.$('.fotorama__active .fotorama__img');
  const image = await page.evaluate(element => element.getAttribute('src'), imageElement);

  console.log("Title: ", title);
  console.log("Price: ", price);
  console.log("Image: ", image);

  // Function to parse table data and return an organized structure
  async function parseTableData() {
    const tableData = {};

    // Find the table rows inside the tbody
    const tableRows = await page.$$('.data.table.additional-attributes tbody tr');

    for (const row of tableRows) {
      const thElement = await row.$('th');
      const tdElement = await row.$('td');

      if (thElement && tdElement) {
        // Extract the label and data values from th and td elements
        const label = await page.evaluate(element => element.textContent.trim(), thElement);
        const dataElement = await tdElement.$('br') ? await tdElement.$x('.//text()') : [tdElement];
        const data = await extractData(dataElement);

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
    }

    return tableData;
  }

  // Function to extract data from cheerio elements
  async function extractData(dataElements) {
    const extractedData = [];

    for (const element of dataElements) {
      const nodeValue = await page.evaluate(node => node.nodeType === 3 ? node.textContent.trim() : node.textContent.trim(), element);

      if (nodeValue) {
        extractedData.push(nodeValue);
      }
    }

    return extractedData;
  }

  // Call the function to get the parsed table data
  const parsedTableData = await parseTableData();

  console.log(parsedTableData);

  const productData = {
    title: title,
    price: price,
    image: image,
    tableData: parsedTableData
  };

  console.log(productData);

  return productData;

  } catch(error) {
    console.log("Error occured while parsing data", error);
  throw error;
  } finally {
    await browser.close();
  }
}
scrapeMyshopProducts();


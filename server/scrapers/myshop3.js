const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeMyshopProducts(productURL) {

  try {
    const response = await axios.get(productURL);
    const htmlContent = response.data;

    const $ = cheerio.load(htmlContent);

    const title = $('.page-title span').text().trim();
    const price = $('.price').text().trim();

    function parseTableData() {
      const tableData = {};

      $('.data.table.additional-attributes tbody tr').each((index, row) => {
        const thElement = $(row).find('th');
        const tdElement = $(row).find('td');

        if (thElement.length && tdElement.length) {
          const label = thElement.text().trim();
          const dataElements = tdElement.find('br').length ? tdElement.find('br').prevAll() : tdElement;
          const data = extractData(dataElements);

          if (label !== 'Detail' && label !== 'Other Detail' && data.length === 1) {
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

    const parsedTableData = parseTableData();

    const productData = {
      title: title,
      price: price,
      tableData: parsedTableData
    };

    console.log(productData);
    return { success: true, data: productData }
  } catch (error) {
    console.error("Error occurred:", error);
    return { error: error.message };
  }
}

module.exports = scrapeMyshopProducts;

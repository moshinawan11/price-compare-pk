const cheerio = require('cheerio');
const axios = require('axios');

async function scrapeDarazProducts() {
  try {
    const response = await axios.get('https://www.daraz.pk/products/apple-iphone-14-pro-max-67-inch-display-physical-sim-esim-pta-approved-1-year-official-mercantile-warranty-i401723923-s1950260316.html?');

    const $ = cheerio.load(response.data);

    const imagesList = [];

    const mainImage = $('.pdp-mod-common-image.gallery-preview-panel__image').attr('src');
    imagesList.push(mainImage);

    $('.pdp-mod-common-image.item-gallery__thumbnail-image').each((index, element) => {
      const imageURL1 = $(element).attr('src');
      const imageURL2 = imageURL1.replace("100x100", "720x720");
      imagesList.push(imageURL2);
    });

    const title = $('.pdp-mod-product-badge-title').text();

    const price = $('.pdp-price.pdp-price_type_normal.pdp-price_color_orange.pdp-price_size_xl').text();

    console.log("Title: ", title);
    console.log("Price: ", price);
    console.log("Images: ", imagesList);

    const brand = $('.pdp-link.pdp-link_size_s.pdp-link_theme_blue.pdp-product-brand__brand-link').text();

    const shippingFee = $('.delivery-option-item__shipping-fee').text();

    const productHighlightsList = [];

    $('.html-content.pdp-product-highlights ul li').each((index, element) => {
      const prodHighlight = $(element).text();
      productHighlightsList.push(prodHighlight);
    });

    const productDetailsList = [];

    $('.html-content.detail-content ul li').each((index, element) => {
      const prodDetail = $(element).text();
      productDetailsList.push(prodDetail);
    });

    const additionalDetailsList = [];

    $('.pdp-general-features ul li').each((index, element) => {
      const title = $(element).find('.key-title').text();
      const value = $(element).find('.html-content.key-value').text();

      additionalDetailsList.push({
        title: title,
        value: value
      });
    });

    const inTheBox = $('.html-content.box-content-html').text();

    console.log("Brand: ", brand);
    console.log("Shipping fee: ", shippingFee);
    if (productHighlightsList.length > 0)
      console.log("Product Highlights: ", productHighlightsList);
    if (productDetailsList.length > 0)
      console.log("Product Details: ", productDetailsList);
    if (additionalDetailsList.length > 0)
      console.log("Additional Details: ", additionalDetailsList);
    console.log("What's in the box: ", inTheBox);
  } catch (error) {
    console.error("Error occurred while scraping: ", error);
  }
}

scrapeDarazProducts();

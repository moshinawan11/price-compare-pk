const puppeteer = require('puppeteer');

async function scrapeDarazProducts(productURL) {
  const browser = await puppeteer.launch();
  try{
  const page = await browser.newPage();

  await page.setDefaultNavigationTimeout(0);

  // Navigate to the website
  await page.goto(`${productURL}`);

  // Wait for the products to load
  await page.waitForSelector('#block-FE0hqcBIES');

  const imagesList = [];

  const mainImgElement = await page.$('.pdp-mod-common-image.gallery-preview-panel__image');
  const mainImage = await page.evaluate(element => element.getAttribute('src'), mainImgElement);

  imagesList.push(mainImage);

  const images = await page.$$('.pdp-mod-common-image.item-gallery__thumbnail-image');

  for (const image of images){
    const imageURL1 = await page.evaluate(element => element.getAttribute('src'), image);
    const imageURL2 = imageURL1.replace("100x100", "720x720");
    imagesList.push(imageURL2);
  }

  const titleElement = await page.$('.pdp-mod-product-badge-title');
  const title = await page.evaluate(element => element.textContent, titleElement);

  const priceElement = await page.$('.pdp-price.pdp-price_type_normal.pdp-price_color_orange.pdp-price_size_xl');
  const price = await page.evaluate(element => element.textContent, priceElement);

  const brandElement = await page.$('.pdp-link.pdp-link_size_s.pdp-link_theme_blue.pdp-product-brand__brand-link');
  const brand = brandElement ? await page.evaluate(element => element.textContent, brandElement) : null;

  const shippingFeeElement = await page.$('.delivery-option-item__shipping-fee');
  const shippingFee = shippingFeeElement ?  await page.evaluate(element => element.textContent, shippingFeeElement) : null;

  const productHighlightsList = [];

  const productHighlights = await page.$$('.html-content.pdp-product-highlights ul li');

  if(productHighlights){

    for(const productHighlight of productHighlights){

      const prodHighlight = await page.evaluate(element => element.textContent, productHighlight);
      productHighlightsList.push(prodHighlight);

    }

  }
  const productDetailsList = [];

  const productDetails = await page.$$('.html-content.detail-content ul li');

  if(productDetails){

    for(const productDetail of productDetails){

      const prodDetail = await page.evaluate(element => element.textContent, productDetail);
      productDetailsList.push(prodDetail);

    }

  }

  const additionalDetailsList = [];

  const additionalDetails = await page.$$('.pdp-general-features ul li');

  if(additionalDetails){

    for(const additionalDetail of additionalDetails){

      const keyElement = await additionalDetail.$('.pdp-general-features ul li .key-title');
      const title = await page.evaluate(element => element.textContent, keyElement);

      const valueElement = await additionalDetail.$('.pdp-general-features ul li .html-content.key-value');
      const value = await page.evaluate(element => element.textContent, valueElement);

      additionalDetailsList.push({
        title: title,
        value: value
      });

    }

  }

  const inTheBoxElement = await page.$('.html-content.box-content-html');
  const inTheBox = inTheBoxElement ? await page.evaluate(element => element.textContent, inTheBoxElement) : null;

  const productData = {
    title: title,
    price: price,
    images: imagesList,
    brand: brand,
    shippingFee: shippingFee,
    productHighlights: productHighlightsList,
    productDetails: productDetailsList,
    additionalDetails: additionalDetailsList,
    inTheBox: inTheBox,
  };
  console.log(productData);
  return { success: true, data: productData };
} catch (error) {
  console.log("Error occurred while scraping: ", error);
  return { success: false, error: error.message };
} finally{
  await browser.close();
}
}

module.exports = scrapeDarazProducts;
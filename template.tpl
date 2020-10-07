___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Olo Serve",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Synchronize events in Olo Serve with the data layer.",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "SALES", "CONVERSIONS"
  ]
}




___TEMPLATE_PARAMETERS___

[
  {
    "type": "CHECKBOX",
    "name": "enhanced",
    "checkboxText": "Enhanced Ecommerce",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "enabledEvents",
    "displayName": "Enabled Events",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "v1.addToCart",
        "checkboxText": "Add to cart",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "v1.removeFromCart",
        "checkboxText": "Remove from cart",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "v1.checkout",
        "checkboxText": "Checkout",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "v0.transaction",
        "checkboxText": "Transaction",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": false,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "v1.transaction",
        "checkboxText": "Transaction",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "v1.clickProductLink",
        "checkboxText": "Click product link",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Not yet implemented",
        "valueValidators": [
          {
            "type": "NUMBER",
            "errorMessage": "This event cannot yet be enabled.",
            "enablingConditions": [
              {
                "paramName": "clickProductLink",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "v1.viewProductDetail",
        "checkboxText": "View product detail",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Not yet implemented",
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER",
            "errorMessage": "This event cannot yet be enabled.",
            "enablingConditions": [
              {
                "paramName": "viewProductDetail",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "v1.productsVisible",
        "checkboxText": "Product(s) visible",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "enhanced",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Not yet implemented",
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER",
            "errorMessage": "This event cannot yet be enabled.",
            "enablingConditions": [
              {
                "paramName": "productsVisible",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const callInWindow = require('callInWindow');
const log = require('logToConsole');
const copyFromWindow = require('copyFromWindow');
const createQueue = require('createQueue');
const Math = require('Math');



/***
 * HELPER FUNCTIONS
 */
const dlp = createQueue('dataLayer');
function dataLayerPush(payload) {
  dlp(payload);
  debugLog('pushing to data layer', payload);
}

function assign() {
  const objects = arguments;
  const len = objects.length;
  const newObject = {};
  for (let i = 0; i < len; i++) {
    for (let key in objects[i]) {
      newObject[key] = objects[i][key];
    }
  }
  return newObject;
}

function keys(obj) {
  const keys = [];
  for (let key in obj) {
    keys.push(key);
  }
  return keys;
}

function roundTo(num, len) {
  len = len || 0;
  len = (Math.floor(num) + '').length + len + 1; // account for the length of the number and the decimal
  return ((num * 1.00000000000000000000001) + '').slice(0, len) * 1;
}

function debugLog(msg, obj) {
  log('Olo Serve GTM: ' + msg);
  if (obj) {
    log(obj);
  }
}

function oloOn(event, configName, cb) {
  if (!cb) {
    cb = configName;
    configName = event;
  }
  // If this event is enabled, listen for it
  if (data[configName]) {
    callInWindow('Olo.on', event, cb);
    debugLog('listening for "' + configName + '" events.');
  }
  else {
    debugLog('NOT listening for "' + configName + '" events.');
  }
}

function mapProduct(product) {
  return {
    name: product.name,
    id: product.id,
    price: product.baseCost || 0.0
  };
}

function mapBasketProduct(bp) {
  return {
    name: bp.productName,
    id: bp.product.id,
    price: bp.unitCost || 0.0,
    quantity: bp.quantity
  };
}

function mapBasketProductLegacy(bp) {
  return {
    sku: bp.product.id,
    name: bp.productName,
    category: bp.categoryName,
    price: bp.unitCost || 0.0,
    quantity: bp.quantity
  };
}

function combineMatchingBasketProductsForEcommerce(basketProducts, key, costKey) {
  key = key || 'id';
  costKey = costKey || 'price';
  const combinedBasketProducts = basketProducts.reduce(function(acc, bp) {
    if (!bp) return acc;
    const cur = acc[bp[key]];
    if (!cur) { // No basket product with this ID, store it an continue
      acc[bp[key]] = bp;
      return acc;
    }

    // Combine this basket product with the last one
    // `price` is a per-unit price, and because different instances of the same ID
    // can have different prices (due to modifiers being added), we do our best
    // and find an average price per unit so that the Google Analytics revenue is correct.
    // Calculate the new average price by taking the current price and quantity for this item,
    // multiplying it out to the total cost, adding the total cost of the new item, and averaging
    // both the existing total cost and the new total cost by the new quantity and rounding to two decimal places.
    const newQuantity = cur.quantity + bp.quantity;
    const newAveragePrice =
      Math.round(100 * ((cur[costKey] * cur.quantity + bp[costKey] * bp.quantity) / newQuantity)) / 100;
    acc[bp[key]] = assign(
      cur,
      {
        price: newAveragePrice,
        quantity: newQuantity
      }
    );

    return acc;
  }, {});

  return keys(combinedBasketProducts).map(function(k) {
    return assign(
      combinedBasketProducts[k],
      {
        price: roundTo(combinedBasketProducts[k].price, 2)
      }
    );
  });
}

function getVendor() {
  return copyFromWindow('Olo.data.vendor') || {};
}




/**
 * EVENT LISTENERS
 */
oloOn('addToCart', function(product) {
  dataLayerPush({
    event: 'addToCart',
    ecommerce: {
      currencyCode: getVendor().currency,
      add: {
        products: [mapBasketProduct(product)]
      }
    }
  });
});

oloOn('removeFromCart', function(product) {
  dataLayerPush({
    event: 'removeFromCart',
    ecommerce: {
      currencyCode: getVendor().currency,
      remove: {
        products: [mapBasketProduct(product)]
      }
    }
  });
});

oloOn('checkout', function(basket, cb) {
  dataLayerPush({
    event: 'checkout',
    ecommerce: {
      checkout: {
        actionField: { step: 0 },
        products: basket.basketProducts.map(mapBasketProduct)
      },
      eventCallback: cb || function() {}
    }
  });
});

oloOn('transaction', function(order, orderSubmission) {
  dataLayerPush({
    event: 'transaction',
    ecommerce: {
      purchase: {
        actionField: {
          id: order.displayId,
          affiliation: order.deliveryMode,
          revenue: order.subTotal,
          tax: order.vendorTax,
          shipping: order.deliveryCharge,
          coupon: orderSubmission.basket.coupon
        },
        products: combineMatchingBasketProductsForEcommerce(
          order.basketProducts.map(mapBasketProduct)
        )
      }
    }
  });
});

oloOn('transaction', 'transactionLegacy', function(order, orderSubmission) {
  dataLayerPush({
    transactionId: order.id,
    transactionAffiliation: order.vendorName,
    transactionTotal: roundTo(order.vendorTotal || 0, 2),
    transactionTax: roundTo(order.vendorTax || 0, 2),
    transactionShipping: order.deliveryCharge,
    transactionZipCode: order.vendor.address ? order.vendor.address.postalCode : undefined,
    transactionStoreNumber: order.vendor.id,
    transactionStoreReference: order.vendor.externalReference,
    transactionProducts: combineMatchingBasketProductsForEcommerce(order.basketProducts.map(mapBasketProductLegacy), 'sku'),
    transactionHandoff: order.handoffDescription,
    transactionRevenue: roundTo(order.subTotal || 0, 2),
    transactionCurrency: getVendor().currency
  });
});

// @todo: not implemented in Serve
oloOn('clickProductLink', function(product) {
  dataLayerPush({
    event: 'clickProductLink',
    ecommerce: {
      currencyCode: getVendor().currency,
      click: {
        products: [mapProduct(product)]
      }
    }
  });
});

// @todo: not implemented in Serve
oloOn('viewProductDetail', function(product) {
  dataLayerPush({
    event: 'viewProductDetail',
    ecommerce: {
      currencyCode: getVendor().currency,
      detail: {
        products: [mapProduct(product)]
      }
    }
  });
});

// @todo: not implemented in Serve
oloOn('productsVisible', function(products) {
  dataLayerPush({
    event: 'productsVisible',
    ecommerce: {
      currencyCode: getVendor().currency,
      impressions: products.map(mapProduct)
    }
  });
});





/**
 * TAG IS FINISHED SETTING UP
 */
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "Olo.on"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "Olo.data.vendor"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Pushes to dataLayer
  code: |
    test('it pushes to dataLayer', function(run) {
      const t = run();
      assertThat(t.queueName).isEqualTo('dataLayer');
    });
- name: Registers events
  code: "test('it registers enabled events', function(run) {\n  const t = run({\n\
    \    addToCart: true, \n    removeFromCart: true,\n    checkout: true,\n    transaction:\
    \ true,\n    clickProductLink: true,\n    viewProductDetail: true,\n    productsVisible:\
    \ true\n  });\n  assertThat(t.events).contains('addToCart');\n  assertThat(t.events).contains('removeFromCart');\n\
    \  assertThat(t.events).contains('checkout');\n  assertThat(t.events).contains('transaction');\n\
    \  assertThat(t.events).contains('clickProductLink');\n  assertThat(t.events).contains('viewProductDetail');\n\
    \  assertThat(t.events).contains('productsVisible');\n});\n\ntest('it does not\
    \ register disabled events', function(run) {\n  const t = run();\n  assertThat(t.events).doesNotContain('addToCart');\n\
    \  assertThat(t.events).doesNotContain('removeFromCart');\n  assertThat(t.events).doesNotContain('checkout');\n\
    \  assertThat(t.events).doesNotContain('transaction');\n  assertThat(t.events).doesNotContain('clickProductLink');\n\
    \  assertThat(t.events).doesNotContain('viewProductDetail');\n  assertThat(t.events).doesNotContain('productsVisible');\n\
    });\n\ntest('it registers the legacy transaction listener', function(run) {\n\
    \  const t = run({transactionLegacy: true});\n  assertThat(t.events).contains('transaction');\n\
    });"
- name: Tag setup completes
  code: |-
    test('it completes setup', function(run) {
      run();
      assertApi('gtmOnSuccess').wasCalled();
    });
- name: Add to cart
  code: "test('it adds to cart', function(run) {\n  const t = run({'v1.addToCart':\
    \ true});\n\n  t.callbacks.addToCart(mockProduct);\n\n  // Verify that the dataLayer\
    \ received the right stuff\n  assertThat(t.dataLayer[0]).isEqualTo({\n    event:\
    \ 'v1.addToCart',\n    ecommerce: {\n      currencyCode: 'USD',\n      add: {\
    \                                \n        products: [{                      \
    \ \n          name: 'Test Product',\n          id: 1234,\n          price: 15.87,\n\
    \          quantity: 2\n        }]\n      }\n    }\n  });\n});"
- name: Remove from cart
  code: "test('it removes from cart', function(run) {\n  const t = run({'v1.removeFromCart':\
    \ true});\n\n  t.callbacks.removeFromCart(mockProduct);\n\n  // Verify that the\
    \ dataLayer received the right stuff\n  assertThat(t.dataLayer[0]).isEqualTo({\n\
    \    event: 'v1.removeFromCart',\n    ecommerce: {\n      currencyCode: 'USD',\n\
    \      remove: {                                \n        products: [{       \
    \                \n          name: 'Test Product',\n          id: 1234,\n    \
    \      price: 15.87,\n          quantity: 2\n        }]\n      }\n    }\n  });\n\
    });"
- name: Checkout
  code: "test('it handles checkout', function(run) {\n  const t = run({'v1.checkout':\
    \ true});\n\n  t.callbacks.checkout(mockBasket, noop);\n\n  // Verify that the\
    \ dataLayer received the right stuff\n  assertThat(t.dataLayer[0]).isEqualTo({\n\
    \    event: 'v1.checkout',\n    ecommerce: {\n      checkout: {  \n        actionField:\
    \ { step: 0 },\n        products: [{                       \n          name: 'Test\
    \ Product',\n          id: 1234,\n          price: 15.87,\n          quantity:\
    \ 2\n        }]\n      },\n      eventCallback: noop\n    }\n  });\n});"
- name: Transaction
  code: "test('it handles transaction', function(run) {\n  const t = run({'v1.transaction':\
    \ true});\n\n  t.callbacks.transaction(mockOrder, mockOrderSubmission);\n\n  //\
    \ Verify that the dataLayer received the right stuff\n  assertThat(t.dataLayer[0]).isEqualTo({\n\
    \    event: 'v1.transaction',\n    ecommerce: {\n      purchase: {  \n       \
    \ actionField: {\n          id: 'asdf',\n          affiliation: 'Pickup',\n  \
    \        revenue: 14.98,\n          tax: 0.72,\n          shipping: 5.99,\n  \
    \        coupon: 'FREEBIE'\n        },\n        products: [{\n          name:\
    \ 'Test Product',\n          id: 1234,\n          price: 17.93,\n          quantity:\
    \ 5\n        }, {\n          name: 'Test Product 2',\n          id: 1235,\n  \
    \        price: 3.99,\n          quantity: 1\n        }]\n      }\n    }\n  });\n\
    });"
- name: Transaction (Legacy)
  code: |-
    test('it handles legacy ecommerce transaction', function(run) {
      const t = run({'v0.transaction': true});

      t.callbacks.transaction(mockOrder, mockOrderSubmission);

      // Verify that the dataLayer received the right stuff
      assertThat(t.dataLayer[0]).isEqualTo({
        transactionId: 1234,
        transactionAffiliation: "Fakes's Tavern",
        transactionTotal: 15.69,
        transactionTax: 0.72,
        transactionShipping: 5.99,
        transactionZipCode: '48104',
        transactionStoreNumber: 'testVendor',
        transactionStoreReference: 'Test Store #37',
        transactionProducts: [{
          name: 'Test Product',
          sku: 1234,
          price: 17.93,
          quantity: 5,
          category: 'Pasta'
        }, {
          name: 'Test Product 2',
          sku: 1235,
          price: 3.99,
          quantity: 1,
          category: 'Pasta'
        }],
        transactionHandoff: 'Curbside Pickup',
        transactionRevenue: 14.98,
        transactionCurrency: 'USD'
      });
    });
- name: Click product link
  code: log('not yet implemented');
- name: View product details
  code: log('not yet implemented');
- name: Products visible
  code: log('not yet implemented');
setup: "const log = require('logToConsole');\n\nconst mockProduct = {            \
  \           \n  productName: 'Test Product',\n  categoryName: 'Pasta',\n  unitCost:\
  \ 15.87,\n  quantity: 2,\n  product: {\n    id: 1234\n  }\n};\n\nconst mockProduct2\
  \ = {                       \n  productName: 'Test Product 2',\n  categoryName:\
  \ 'Pasta',\n  unitCost: 3.99,\n  quantity: 1,\n  product: {\n    id: 1235\n  }\n\
  };\n\nconst mockProduct3 = {                       \n  productName: 'Test Product',\n\
  \  categoryName: 'Pasta',\n  unitCost: 19.31,\n  quantity: 3,\n  product: {\n  \
  \  id: 1234\n  }\n};\n\nconst mockBasket = {\n  basketProducts: [mockProduct]\n\
  };\n\nconst mockOrder = {\n  basketProducts: [mockProduct, mockProduct2, mockProduct3],\n\
  \  id: 1234,\n  displayId: 'asdf',\n  deliveryMode: 'Pickup',\n  handoffDescription:\
  \ 'Curbside Pickup',\n  subTotal: 14.98,\n  vendorTax: 0.72,\n  deliveryCharge:\
  \ 5.99,\n  vendorTotal: 15.69999999,\n  vendorName: \"Fakes's Tavern\",\n  vendor:\
  \ {\n    id: 'testVendor',\n    externalReference: 'Test Store #37',\n    address:\
  \ {\n      postalCode: '48104'\n    }\n  }\n};\n\nconst mockOrderSubmission = {\n\
  \  basket: {\n    coupon: 'FREEBIE'\n  }\n};\n\nconst noop = function() {};\n\n\
  function test(name, cb) {\n  cb(function(data) {\n    const dataLayer = [];\n  \
  \  const events = [];\n    const callbacks = {};\n    let queueName;\n\n    // Mock\
  \ vendor return\n    mock('copyFromWindow', {currency: 'USD'});\n\n    // Mock creating\
  \ a data layer\n    mock('createQueue', function(q) {\n      queueName = q;\n  \
  \    return function(d) {\n        dataLayer.push(d);\n      };\n    });\n\n\n \
  \   mock('callInWindow', function(_, eName, cb) {\n      cb = cb || noop;\n    \
  \  events.push(eName);\n      callbacks[eName] = cb;\n    });\n\n    runCode(data\
  \ || {});\n\n    log('Running test: ' + name);\n    \n    return {\n      events:\
  \ events,\n      callbacks: callbacks,\n      dataLayer: dataLayer,\n      queueName:\
  \ queueName\n    };\n  });\n}"


___NOTES___

Created on 9/26/2020, 7:57:35 AM



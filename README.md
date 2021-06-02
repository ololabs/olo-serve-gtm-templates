# Olo Serve GTM Template

## Introduction

The easiest way to integrate Google Tag Manager (and Google Analytics) with Olo Serve is to use this template to automatically create custom GTM events for each "global event" emitted from Olo Serve. These custom events map to each of the [GA Enhanced Ecommerce](https://developers.google.com/tag-manager/enhanced-ecommerce) activities, and they can be used to pass data from Serve to GA.

[Read more about Olo Serve's global data and events here.](#todo-bloomfire?)

## Simple Setup

The fastest way to get started with Olo Serve and GTM is to [import a container configuration](https://support.google.com/tagmanager/answer/6106997?hl=en#import) from [our Github repository](https://github.com/ololabs/olo-serve-gtm-templates/container). This will install the Olo Serve GTM templates and add the appropriate triggers, variables, and tags to track interactions with Serve in Google Analytics. The configurations support either GA4 or Universal Analytics, and they are ideal for new GTM setups.

If you are worried about importing a configuration conflicting with your existing GTM setup, follow one of the manual setup instructions below.

TODO:
(UA Template)
(GA4 Template)
(Can we import just parts?)

## Manual Setup (GA4)

### 1. Import the Olo Serve template

To start using this template, import it from the Community Template Gallery.

![Image of importing a tag template](./images/2-add-template-from-gallery.png)
![Image of imported gallery tag template](./images/3-template-added.png)

TODO: all the other steps

Add the Serve Integration Tag
Add web, iOS and Android variables
Add triggers
Add tags

## Manual Setup (UA)

TODO: call out changed event names here.

### 1. Import the Olo Serve template

To start using this template, import it from the Community Template Gallery.

![Image of importing a tag template](./images/2-add-template-from-gallery.png)
![Image of imported gallery tag template](./images/3-template-added.png)

### 2. Create a new tag

Once the template has been added to your container, create a new tag that uses it.

![Image of empty tag list](./images/4-tag-list.png)
![Image of blank new tag](./images/5-add-tag.png)
![Image of selecting tag type](./images/6-select-template-tag.png)
![Image of naming the new tag](./images/7-name-tag.png)

### 3. Configure the tag and add a trigger

Next, you can configure which Serve events to listen for, and set a DOM Ready trigger to have the listeners start as soon as the app is ready. Each enabled event will push a "custom event" to the GTM data layer when that event is fired from Serve.

![Image of selecting enabled events](./images/8-select-events.png)
![Image of an empty trigger list](./images/9-add-trigger.png)
![Image of a blank new trigger](./images/10-create-dom-trigger.png)
![Image of selecting a DOM Ready trigger](./images/11-dom-ready-trigger.png)
![Image of a configured DOM Ready trigger](./images/12-dom-ready-trigger-created.png)
![Image of a configured Serve template integration](./images/13-olo-serve-integration-created.png)

### 4. Create a custom event trigger

In order to send data to Google Analytics (step #5), you first need to create a trigger based on a custom event. This example creates a trigger for the `addToCart` custom event. [Click here to view a list of all available events.](#available-events)

![Image of a blank new trigger](./images/14-create-custom-event-trigger.png)
![Image of selecting a trigger type](./images/15-select-trigger-type.png)
![Image of a configured custom event trigger](./images/16-configure-trigger.png)

### 5. Create a Google Analytics tag

The final step to pass data from Serve to Google Analytis is to create a GA tag that interacts directly with the data layer. [A full list of Enhanced Ecommerce activities and how to configure them is available here.](https://developers.google.com/tag-manager/enhanced-ecommerce) Pay close attention to the "+ See the Tag Configuration for the Example" button after each section.

![Image of configuring a Google Analytics tag](./images/17-create-ga-event-tag.png)
![Image of a configured Google Analytics tag](./images/18-set-ga-event-tag-trigger.png)
![Image of a created Add to Cart tag integration](./images/19-tag-list.png)

## Available Events

Event Name | Description
--- | ---
addToCart | [A product is added to the cart.](https://developers.google.com/tag-manager/enhanced-ecommerce#add)
removeFromCart | [A product is removed from the cart.](https://developers.google.com/tag-manager/enhanced-ecommerce#cart)
checkout | [A user proceeds to the Checkout page.](https://developers.google.com/tag-manager/enhanced-ecommerce#checkout)
purchase | [A user has completed their purchase.](https://developers.google.com/tag-manager/enhanced-ecommerce#purchases)
clickProductLink | [A user clicks a product link.](https://developers.google.com/tag-manager/enhanced-ecommerce#product-clicks)
viewProductDetail | [A user views the details and/or configures a product.](https://developers.google.com/tag-manager/enhanced-ecommerce#details)
productsVisible | [A product becomes visible on the screen.](https://developers.google.com/tag-manager/enhanced-ecommerce#product-impressions)
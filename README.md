# NativeJ

## Overview

**NativeJ**, is a simple Javascript Library for selecting DOM Nodes, adding, removeing and triggering Events and AJAX Support with an (almost) compatible jQuery Interface.

## Why
jQuery is the best Javascript library for Rapid Prototyping but it comes with support for old browsers (jQuery 2.x doesn't make it better), it's a little bit slow and too big (especially for mobile Phones)

## Support

### Browser Support

Tested with current browser versions and it works.
This table will be extended and give you an overview which browsers are tested and are compatible.

Browser      | Compatible
:----------- | ----------:
Safari 7.0.1 | yes

Feel free to download this project and run the unittests in the `index.html`

### Javascript Frameworks
Framework      | Compatible
:------------- | ----------:
Backbone 1.1.0 | yes


### Supported jQuery functions

on(event [, selector], handler)

off(event [, selector], handler)

trigger(eventType)

DOM Selection

AJAX Support

### Syntax

$$(&lt;selector&gt;)

$$.ajax

### Usage in your project

Built files are in the `dist` folder. In the moment it's stll not qualified for production webpages.

## Contributions

I appreciate support, comments and commits.

### Install
```shell
npm install
```
### Develop
```shell
grunt watch
```

Check and edit the public/js/lib/native/0.0.3/nativej.coffee file.

### Test
Not supported yet. Please run the `index.html` in your browser.

```shell
grunt test
```
### Build
```shell
grunt
```
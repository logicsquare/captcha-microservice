# Captcha-Microservice ![node >= 10](https://badgen.net/badge/node/%3E=10/green)

This microservice is meant to be used for generating a captcha image (in embeddable SVG format), and later, also to validate it against a response providing the text shown in the said image. Each captcha is uniquely identified by a short key.

The microservice is built using the Express framwork, and uses Redis as a data store.

# Running the Microservice
0. Clone this git repo, `cd` and run `npm install`. Make sure `node` (>= 10.0.0)  and `redis` is installed and ready.
1. Rename the file `env.SAMPLE` to `.env` and populate its fields as required. In particular, check the `PORT` to be used (`9090` is the default). (Note that `.env` file is gitignored, so you need one in each of the environments you will be running the microservice on. For further  details, check [dotenv](https://www.npmjs.com/package/dotenv))
2. To run the microservice in dev mode, just use `npm start`. In prod, you may use latest versions of `pm2` to run the `server.js` file.

# API
The microservice exposes two RESTful routes: one for generating & the other for validating the Captcha.

### Authentication:
The routes may optionally be authenticated using a Token string. If you wish to enable auth, set the value `REQUIRE_AUTH="yes"` and specify the secret access token string in the key `ACCESS_TOKEN="xxxxyyyyzzzz"` within the `.env` file.
Once enabled, all HTTP requests to the microservice will need to authenticate first by setting the `Authorization` header to the format `Token xxxxyyyyzzzz`.

### Routes:
1. `POST /generate`
#### Parameters
| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| color     	| Boolean	|  **optional (Default `true`)** <p>Whether the captcha image should be in colors</p> |
| background	| String  |  **optional (Default `#ffffff`)** <p>Background color</p>	|
| size		  	| String  | **optional (Default `4`)** <p>Length of Captcha text</p> |
| timeout		  | Number  | **optional (Default `10`)** <p>Timeout in Minutes</p>	|

#### Example Success Response (JSON)
```
    {
      key: "xyz123abc",
      captchaSvg: "<svg ..... /svg>"
    }
```


2. `POST /validate`
#### Parameters
| Name    | Type      | Description                          |
|---------|-----------|--------------------------------------|
| text		| String			| **Mandatory** <p>The captcha text response to validate</p> |
| key		  | String			| **Mandatory** <p>The unique key obtained from `POST /generate`</p>	|

#### Validation Success/Error:
If the Captcha is validated succesfully, the HTTP response status code is `200 OK` with a message body like `Valid Captcha!`.

If the validation fails (e.g. wrong captcha text or expired captcha), the HTTP response status code will always be `500 Internal Server Error`. The message body will correspond to the precise error faced.

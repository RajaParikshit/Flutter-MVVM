<?php

error_reporting(-1);
ini_set('display_errors', 'On');

require '.././lib/Slim/Slim.php';

include_once '../include/config.php';

\Slim\Slim::registerAutoloader();

$app = new \Slim\Slim();

/**
 * User Login
 */
$app->post('/user/login', function() use ($app) {
    // check for required params
    verifyRequiredParams(array(USER_NAME, USER_PASSWORD));

    // reading post params
    $user_name = $app->request->post(USER_NAME);
    $user_password = $app->request->post(USER_PASSWORD);


    if ($user_name == 'Bond007' && $user_password == 'VESPER836547'){
	     $response[RESPONSE] = LOGIN_SUCCESSFUL;
    }else{
        $response[RESPONSE] = LOGIN_UNSUCCESSFUL;
    }

    // echo json response
    echoRespnse(200, $response);
});


/**
 * Verifying required params posted or not
 */
function verifyRequiredParams($required_fields) {
    $error = false;
    $error_fields = "";
    $request_params = array();
    $request_params = $_REQUEST;
    // Handling PUT request params
    if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
        $app = \Slim\Slim::getInstance();
        parse_str($app->request()->getBody(), $request_params);
    }
    foreach ($required_fields as $field) {
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) {
            $error = true;
            $error_fields .= $field . ', ';
        }
    }

    if ($error) {
        // Required field(s) are missing or empty
        // echo error json and stop the app
        $response = array();
        $app = \Slim\Slim::getInstance();
        $response["error"] = true;
        $response["message"] = 'Required field(s) ' . substr($error_fields, 0, -2) . ' is missing or empty';
        echoRespnse(400, $response);
        $app->stop();
    }
}


function IsNullOrEmptyString($str) {
    return (!isset($str) || trim($str) === '');
}

/**
 * Echoing json response to client
 * @param String $status_code Http response code
 * @param Int $response Json response
 */
function echoRespnse($status_code, $response) {
    $app = \Slim\Slim::getInstance();
    // Http response code
    $app->status($status_code);

    // setting response content type to json
    $app->contentType('application/json');

    echo json_encode($response);
}

$app->run();
?>

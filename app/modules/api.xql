xquery version "3.1";
(: The APIResolver :)

import module namespace config="https://bahr-zeitleiste.acdh-dev.oeaw.ac.at/config" at "config.xqm";
import module namespace api="https://bahr-zeitleiste.acdh-dev.oeaw.ac.at/api" at "api.xqm";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare namespace tei="http://www.tei-c.org/ns/1.0";

(: local functions :)
 declare function local:test_response() {
    if (contains($url, '/api/v1.0/')) then
            (:start Interaction with API:)
            <response>
                "API Call: " method: {$method}; query: {$query}; servletPath {$servletPath}; url                {$url}; apicall {$apicall}; <!-- headerNames {$headerNames}; --> Accept: {$headerAccept}
            </response>
        else
            (: Incorrect Base, redirect to Documentation :)
            response:redirect-to($APIDocu)
};

declare function local:wrapXMLApiCall($response) {
    (:~ Wraps the response with the API Call root-element :)
    <ApiResponse>{$response}</ApiResponse>
};


declare function local:QueryParamMap() {
    (:~ Parse Query Params into map to pass to API Functions :)
    let $paramNames := request:get-parameter-names()
        let $paramMap := 
        map:new(
            
            for $paramName in $paramNames 
                return
                    map:entry($paramName, request:get-parameter($paramName,'none'))
                )
    return $paramMap
};


 (: Set some Basic Stuff :)
 (: Put the Swagger Documentation here :)
 let $APIDocu := "https://bahr-zeitleiste.acdh-dev.oeaw.ac.at/documentation/api.html"
 




(: Stuff to determine request :)


let $method := request:get-method()
(: let $headerNames := request:get-header-names() :)
let $headerAccept := request:get-header('Accept')
let $query := request:get-query-string()
let $queryParamNames := request:get-parameter-names()
let $servletPath := request:get-servlet-path()
let $url := request:get-url()
let $apicall := tokenize($url, '/api/v1.0/')[2]
return
    
    (: /testme :)
    if ($apicall eq "testme") then
        local:wrapXMLApiCall(api:testme())
    
    (: /id/{Id} :)
    else if (matches($apicall, 'id/.*')) then
        let $id := replace(tokenize($apicall,'/')[2],"(.*)","$1")
        return
        api:getTEI($id)   
    
    (: /id :)
    else if (matches($apicall, '^id$')) then
        <debug>list all ids</debug>
    
    (: default :)
    else 
    (
        response:set-status-code(400),
        local:wrapXMLApiCall(<error>Error: "{$apicall}" not implemented! See documentation: {$APIDocu}</error>)
    ) 
    

        
    
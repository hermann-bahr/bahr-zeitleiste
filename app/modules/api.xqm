xquery version "3.1";


(:
 : API
 :)
module namespace api="https://bahr-zeitleiste.acdh-dev.oeaw.ac.at/api";

import module namespace config="https://bahr-zeitleiste.acdh-dev.oeaw.ac.at/config" at "config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function api:testme() {
    (:~ Function to test a simple API call
    @returns It works!
    :)
    "It works!"
};

declare function api:getTEI($id as xs:string) {
    (:~ Get the Element encoded in TEI
    @params $Id xml:id of the Element
    :)
    if (collection($config:data-root)/id($id)) then
        collection($config:data-root)/id($id)
    else 
        (
        response:set-status-code(400),
        <error>{$id} not found!</error>
        )
};

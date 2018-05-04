### Swagger code generation

This repository relies on the following docker file in order to run swagger-codegen inside a docker container:
https://hub.docker.com/r/jimschubert/swagger-codegen-cli/

We're currently using the version 2.3.1 of swagger-codegen.


### Generating the API Client

Copy the API swagger json/yaml spec files to the local `/input` directory.

The API v1 json/yaml spec can be found using the StopLight export link on our documentation page: `https://docs.jumpcloud.com/1.0`.

The API v2 json/yaml spec can be found using the StopLight export link on our documentation page: `https://docs.jumpcloud.com/2.0`.

Update the version number for each package in `config_v1.json` and `config_v2.json`.

To generate the API v1 client, run the command below (assuming your API v1 yaml file is `input/index1.yaml`):  

```
$ docker-compose run --rm swagger-codegen generate -i /swagger-api/yaml/index1.yaml -l ruby -c /config/config_v1.json -o /swagger-api/out/jcapiv1
```
This will generate the API v1 client files under `output/jcapiv1`

To generate the API v2 client, run the command below (assuming your API v2 yaml file is `input/index2.yaml`):  

```
$ docker-compose run --rm swagger-codegen generate -i /swagger-api/yaml/index2.yaml -l ruby -c /config/config_v2.json -o /swagger-api/out/jcapiv2
```
This will generate the API v2 client files under `output/jcapiv2`

Once you are satisfied with the generated API client, you can replace the existing files under the `jcapiv1` and `jcapiv2` folders with your generated files.


There is apparently a bug in swagger-codegen when it comes to generating code for enum types in Ruby.
After generating the code, run the following sed commands in order to fix this bug for the 2 files that use the enum type (graph_type and group_type):
```
$ sed -i '' 's/c.to_s/GraphType::const_get(c)/g' jcapiv2/lib/jcapiv2/models/graph_type.rb
$ sed -i '' 's/c.to_s/GraphType::const_get(c)/g' jcapiv2/lib/jcapiv2/models/group_type.rb
```

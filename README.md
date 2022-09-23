
# Keycloak + Ldap

Proyecto dockerizado en donde se implementa Keycloak junto a PostgreSQL y tambien OpenLdap. OpenLdap es una imagen que contiene datos de ejemplos para poder tener una prueba integral.



## Pasos iniciales

#### Clonar repositorio
```
  git clone http://xxxxxx
```
#### Iniciar los contenedores
```
  docker-compose up -d
```
#### Ingresar a keycloak y crear nuevo Realm
``` 
  http://localhost:8080/
```
| User | Pass     |
| :-------- | :------- |
| `admin` | `admin` |

**Importar ``starfleet-full-realm.json``:** Add realm --> Import: Select file --> elegir el archivo .json


## User / role / group

(la contraseña de cada usuario es `password`)

| User   | LDAP Role            | Group-inferred Role |
| :----- | :------------------- | :------------------ |
| picard | `CAPTAIN`            | `HUMAN`             |
| riker  | `COMMANDING_OFFICER` | `HUMAN`             |
| data   | `OPERATIONS_OFFICER` | `ANDROID`           |
| worf   | `SECURITY_OFFICER`   | `KLINGON`           |
| tasha  | `SECURITY_OFFICER`   | `HUMAN`             |
| deanna | `COUNSELOR`          | `HUMAN`             |

## Postman
Usando Postman podemos obtener un token válido con los usuarios y password correspondientes al LDPAP. Además, se configuró para obtener los roles de cada usuario.

Token User:
```http
curl -L -X POST 'http://localhost:8080/auth/realms/starfleet/protocol/openid-connect/token' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'username=riker' \
--data-urlencode 'password=password' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'scope=openid' \
--data-urlencode 'client_id=ldap' \
--data-urlencode 'client_secret={{client_secret}}'
```

User Info:
```http
curl -L -X POST 'http://localhost:8080/auth/realms/starfleet/protocol/openid-connect/userinfo' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Authorization: Bearer {{token}}'
```

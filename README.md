# kube-news

## Repositório disponibilizado
Feito um fork de 

## Docker
```sh
docker build -t gustaff77/kube-news:v1 .
```
para rodar a aplicação use
Note que é preciso colocar as credenciais de um banco de dados postgres para funcionar
```sh
docker run --name k-news --rm -t -e DB_DATABASE="" -e DB_USERNAME="" -e DB_PASSWORD="" -e DB_HOST="" gustaff77/kube-news 
```

Caso precise de um banco use **DB_HOST="172.0.0.1"** (ou seu ip do docker) no comando acima e crie um container postgres com 
```sh
docker run -e POSTGRES_DB="" -e POSTGRES_USER="" -e POSTGRES_PASSWORD="" -e DB_HOST="127.0.0.1" postgres:15.0-alpine 
```

Por fim para subir em meu repositorio
```sh
docker push gustaff77/kube-news:v1
```
repetido para a tag latest


### K3D
Para criar o cluster
```sh
k3d cluster create meucluster -p "80:31000@loadbalancer"
```
Então para rodar neste cluster
```sh
kubectl apply -f deployment.yaml
```
Então acesse o browser na porta 80 (ou na que você colocou no comando de criação do cluster)




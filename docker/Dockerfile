# imagen de lambda oficial de aws
FROM public.ecr.aws/lambda/python:3.13

COPY requirements.txt ${LAMBDA_TASK_ROOT}

# RUN se usa para ejecutar comandos que buildean la imagen
# instalo dependencias (en este caso solo psycopg2 porque la imagen viene con boto3)
RUN pip install --no-cache-dir -r requirements.txt

# copio código lambda a mi contenedor
COPY lambda_function_local_testing.py ${LAMBDA_TASK_ROOT}

# CMD es comando default para que el container ejecute en startup
CMD [ "lambda_function_local_testing.lambda_handler" ]

# comando para testear lambda
# es POST y no GET porque para triggerear una funcion el RIE (runtime interface emulator de lambda) necesita que yo mande un POST 
# curl manda POST pero en el payload mandamos GET que es nuestra verdadera intención
# no necesita el path en realidad porque en ningun lado le digo a la lambda que vaya a buscar ese evento especifico
# curl -XPOST 'http://localhost:9000/2015-03-31/functions/function/invocations' -H 'Content-Type: application/json' -d '{"httpMethod": "GET", "path": "/info", "queryStringParameters": null, "body": null}' 
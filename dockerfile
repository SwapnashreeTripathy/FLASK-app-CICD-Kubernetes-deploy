#in Multistages docker file, Each stage will create 1 layer, which helps in using less resouces.

FROM python:3.9 AS build
WORKDIR /app
#COPY ./requirements.txt .
COPY . .
RUN pip3 install -r requirements.txt


#below stage is optional, here we're testing test_app.py file before creating the docker image/ before running the app.py file
FROM python:3.9 AS TEST
WORKDIR /test
#COPY --from=build(copy files from "WORKDIR"</app>  of previous Stage/build( TEST), to current WORKDIR of stage named "TEST")
COPY --from=build /app .
COPY --from=build /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
#or python3 test_app.py
RUN python3 -m unittest test_app.py   


FROM python:3.9
WORKDIR /deploy
COPY --from=TEST /test .
COPY --from=TEST /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
EXPOSE 3000
CMD ["python", "app.py"]


# while running "requirments.txt" the flask module got installed in "/usr/local/lib/python3.9/site-packages". 
#So copying dir "/usr/local/lib/python3.9/site-packages" from "a docker Stage named "Build"" to current docker stage of WORKDIR .
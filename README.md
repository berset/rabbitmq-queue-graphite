# rabbitmq-queue-graphite

Example usage, as rabbitmq sidekick, in kubernetes deployment.

```
apiVersion: v1
kind: ReplicationController
metadata:
  name: rabbitmq
spec:
  replicas: 1
  selector:
    name: rabbitmq
  template:
    metadata:
      labels:
        name: rabbitmq
    spec:
      containers:
        - name: rabbitmq
          image: rabbitmq:3.5.3-management
          ports:
            - name: queue-api
              containerPort: 5672
            - name: mgmt
              containerPort: 15672
          volumeMounts:
            - name: rabbitmq-data
              mountPath: /var/lib/rabbitmq
          env:
            - name: RABBITMQ_ERLANG_COOKIE
              value: verySecret
        - name: stats-reporter
          image: quay.io/campanja/rabbitmq-metrics:v0.0.2
          env:
            - name: RABBITMQ_ERLANG_COOKIE
              value: verySecret
      volumes:
        - name: rabbitmq-data
          emptyDir: {}
```

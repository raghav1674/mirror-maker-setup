const { Kafka } = require('kafkajs')
const { generateAuthTokenFromRole } = require('aws-msk-iam-sasl-signer-js')

async function oauthBearerTokenProvider(region, awsRoleArn, awsRoleSessionName) {
    const authTokenResponse = await generateAuthTokenFromRole({ region, awsRoleArn, awsRoleSessionName });
    console.log("=====================================")
    console.log("Generated token response: ", authTokenResponse)
    console.log("=====================================")
    return {
        value: authTokenResponse.token
    }
}



exports.handler = async (event) => {

    const messages = []

    const topic_name = process.env.TOPIC_NAME
    const bootstrap_servers = process.env.BOOTSTRAP_SERVER.split(',')
    const consumer_group = process.env.CONSUMER_GROUP
    const region = process.env.REGION
    const aws_role_arn = process.env.MSK_ASSUME_ROLE_ARN

    console.log("=========== DETAILS ==================")

    console.log("TOPIC_NAME: ", topic_name)
    console.log("BOOTSTRAP_SERVER: ", bootstrap_servers)
    console.log("CONSUMER_GROUP: ", consumer_group)
    console.log("REGION: ", region)
    console.log("MSK_ASSUME_ROLE_ARN: ", aws_role_arn)

    console.log("=====================================")


    console.log("============= CHECKING CONNECTIVITY ==================")
    console.log("Checking connection to Kafka")

    require('net').createConnection({ host: bootstrap_servers.at(0).split(":").at(0), port: 9098 }, () => console.log('Connected')).on('error', console.error).end();

    console.log("=====================================")


    console.log("============= AUTHENTICATING TO MSK ==================")


    const kafka = new Kafka({
        clientId: 'test-client',
        brokers: bootstrap_servers,
        ssl: true,
        sasl: {
            mechanism: 'oauthbearer',
            oauthBearerProvider: () => oauthBearerTokenProvider(region, aws_role_arn, 'test-session')
        }
    })

    console.log("=====================================")

    console.log("===== CREATING TOPIC IF NOT EXISTS =====")

    const admin = kafka.admin()
    await admin.connect()
    const topic = await admin.listTopics()
    if (topic.includes(topic_name)) {
        console.log("Topic already exists")
    } else {
        console.log("Creating topic")
        await admin.createTopics({
            topics: [{ topic: topic_name, numPartitions: 1, replicationFactor: 1 }],
        })
    }
    await admin.disconnect()

    console.log("=====================================")


    console.log("============= PRODUCING AND CONSUMING ==================")

    const producer = kafka.producer()
    const consumer = kafka.consumer({ groupId: consumer_group })

    // Producing
    await producer.connect()
    await producer.send({
        topic: topic_name,
        messages: [
            { value: 'Hello KafkaJS user!' },
        ],
    })

    // Consuming
    await consumer.connect()
    await consumer.subscribe({ topic: topic_name, fromBeginning: true })

    await consumer.run({
        eachMessage: async ({ topic, partition, message }) => {
            console.log({
                partition,
                offset: message.offset,
                value: message.value.toString(),
            })
            console.log("=====================================")
            console.log("message: ", message.value.toString())
            console.log("=====================================")
        }
    })
}

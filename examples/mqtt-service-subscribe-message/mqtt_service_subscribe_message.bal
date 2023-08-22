import ballerina/lang.value;
import ballerina/log;
import ballerina/mqtt;
import ballerina/time;
import ballerina/uuid;

public type TemperatureDetails readonly & record {
    string deviceId;
    time:Utc timestamp;
    decimal temperature;
};

service on new mqtt:Listener(mqtt:DEFAULT_URL, uuid:createType1AsString(), "mqtt/topic") {
    remote function onMessage(mqtt:Message message) returns error? {
        TemperatureDetails 'order = check value:fromJsonStringWithType(check string:fromBytes(message.payload));
        log:printInfo(string `Received temperature details from device: ${'order.deviceId} at ${time:utcToString('order.timestamp)} with temperature: ${'order.temperature}`);
    }
}

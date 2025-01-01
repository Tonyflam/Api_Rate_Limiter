import List "mo:base/List";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Principal "mo:base/Principal";


actor arl{
  
//Data types

type Client = {
    apiKey: Text;
    createdAt: Time.Time;
};

type RequestLog = {
    apiKey: Text;
    timestamp: Time.Time;
};

type RateLimit = {
    requestsPerSecond: Nat;
    requestsPerMinute: Nat;
    requestsPerHour: Nat;
};

//stable variables

stable var clients: List.List<Client> = List.nil<Client>();
stable var requestLogs: List.List<RequestLog> = List.nil<RequestLog>();
stable var rateLimits: RateLimit = {
    requestsPerSecond = 5;
    requestsPerMinute = 100;
    requestsPerHour = 1000;
};

//Register Client

public func registerClient(): async Text {
    let apiKey = Principal.toText(Principal.fromActor(arl)); // Generate unique key
    let newClient: Client = {
        apiKey = apiKey;
        createdAt = Time.now();
    };
    clients := List.push(newClient, clients);
    return apiKey;
};

//Log Request

private func logRequest(apiKey: Text): async (){
    let timestamp = Time.now();
    let newLog: RequestLog = {
        apiKey = apiKey;
        timestamp = timestamp;
    };
    requestLogs := List.push(newLog, requestLogs);
    
};

//Enforce Rate limites

private func enforceRateLimit(apiKey: Text): async Bool {
    let now = Time.now();

    // Filter requests for this API key
    let recentRequests = List.filter(requestLogs, func(log: RequestLog): Bool {
        log.apiKey == apiKey and log.timestamp >= now - 60_000_000_000; // Last 1 minute
    });

    let requestsPerSecond = List.filter(recentRequests, func(log: RequestLog): Bool {
        log.timestamp >= now - 1_000_000_000; // Last 1 second
    });

    let requestsPerHour = List.filter(requestLogs, func(log: RequestLog): Bool {
        log.apiKey == apiKey and log.timestamp >= now - 3_600_000_000_000; // Last hour
    });

    // Enforce limits
    if (List.size(requestsPerSecond) > rateLimits.requestsPerSecond or
        List.size(recentRequests) > rateLimits.requestsPerMinute or
        List.size(requestsPerHour) > rateLimits.requestsPerHour) {
        return false; // Exceeded rate limit
    };

    return true;
};

//Handle Api Request

public func handleRequest(apiKey: Text): async Text {
    let clientExists = List.find(clients, func(c: Client): Bool { c.apiKey == apiKey });
    if (clientExists == false ) {
        return "Invalid API key";
    };
    let rateLimitresult = await enforceRateLimit(apiKey);

    if (rateLimitresult == false ) {
        return "429 Too Many Requests";
    };

    await logRequest(apiKey);
    return "Request processed successfully";
};

//Check usage

public func checkUsage(apiKey: Text): async { second: Nat; minute: Nat; hour: Nat } {
    let now = Time.now();
    let secondUsage = List.size(List.filter(requestLogs, func(log: RequestLog): Bool {
        log.apiKey == apiKey and log.timestamp >= now - 1_000_000_000;
    }));

    let minuteUsage = List.size(List.filter(requestLogs, func(log: RequestLog): Bool {
        log.apiKey == apiKey and log.timestamp >= now - 60_000_000_000;
    }));

    let hourUsage = List.size(List.filter(requestLogs, func(log: RequestLog): Bool {
        log.apiKey == apiKey and log.timestamp >= now - 3_600_000_000_000;
    }));

    return { second = secondUsage; minute = minuteUsage; hour = hourUsage };
};


//Add helper Fuction

public func compressLogs(): async Text {
    let cutoff = Time.now() - 3_600_000_000_000; // Keep only last hour
    requestLogs := List.filter(requestLogs, func(log: RequestLog): Bool {
        log.timestamp >= cutoff;
    });
    return "Logs compressed successfully";
}
};

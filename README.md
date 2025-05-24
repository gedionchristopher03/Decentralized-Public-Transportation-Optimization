# Decentralized Public Transportation Optimization

A blockchain-based smart contract ecosystem that enables transparent, data-driven optimization of public transportation systems. This platform combines transit authority verification, real-time ridership tracking, and intelligent schedule optimization to create efficient, responsive urban mobility solutions.

## Overview

The Decentralized Public Transportation Optimization system consists of five interconnected smart contracts that work together to revolutionize public transit management:

- **Transit Agency Verification Contract**: Establishes legitimacy of transportation authorities
- **Route Registration Contract**: Maintains a decentralized catalog of service paths and stops
- **Ridership Tracking Contract**: Monitors real-time passenger volumes and travel patterns
- **Schedule Optimization Contract**: Dynamically adjusts service timing based on demand data
- **Performance Measurement Contract**: Tracks service reliability and operational metrics

## Architecture

### System Components

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Transit Agencies│───▶│   Verification  │───▶│     Route       │
│                 │    │    Contract     │    │  Registration   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                                       │
┌─────────────────┐    ┌─────────────────┐           │
│   Passengers    │───▶│ Ridership Track │◄──────────┘
│   & Vehicles    │    │   Contract      │
└─────────────────┘    └─────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌─────────────────┐
│ Schedule Updates│◄───│   Schedule      │
│   & Alerts      │    │ Optimization    │
└─────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │   Performance   │
                       │  Measurement    │
                       └─────────────────┘
```

## Smart Contracts

### 1. Transit Agency Verification Contract

**Purpose**: Validates and manages transportation authority credentials to ensure system integrity.

**Key Features**:
- Government agency verification process
- Authority credential validation
- Operational license verification
- Multi-jurisdictional support
- Compliance monitoring
- Dispute resolution for inter-agency conflicts

**Functions**:
- `verifyTransitAgency(address agency, bytes32 governmentId, string jurisdiction)`
- `updateAgencyStatus(address agency, uint8 status, string reason)`
- `getAgencyCredentials(address agency) returns (AgencyInfo memory)`
- `validateOperationalLicense(address agency, bytes32 licenseHash)`

### 2. Route Registration Contract

**Purpose**: Creates a decentralized registry of transportation routes, stops, and service areas.

**Key Features**:
- Route tokenization with unique identifiers
- Stop location mapping with GPS coordinates
- Service area boundary definitions
- Multi-modal transportation support (bus, train, tram, ferry)
- Route topology and connection mapping
- Real-time route status updates

**Functions**:
- `registerRoute(string memory routeName, address[] memory stops, uint8 transportMode)`
- `addRouteStop(uint256 routeId, address stopLocation, uint256 sequence)`
- `updateRouteStatus(uint256 routeId, uint8 status, string memory reason)`
- `getRouteDetails(uint256 routeId) returns (Route memory)`
- `findRoutesBetweenStops(address origin, address destination) returns (uint256[] memory)`

### 3. Ridership Tracking Contract

**Purpose**: Monitors passenger volumes, travel patterns, and demand fluctuations across the network.

**Key Features**:
- Real-time passenger counting via IoT sensors
- Anonymous ridership data collection
- Peak/off-peak demand analysis
- Seasonal ridership pattern recognition
- Crowding level monitoring
- Predictive demand modeling
- Privacy-preserving analytics

**Functions**:
- `recordBoardings(uint256 routeId, address stopId, uint256 passengerCount, uint256 timestamp)`
- `recordAlightings(uint256 routeId, address stopId, uint256 passengerCount, uint256 timestamp)`
- `getCurrentOccupancy(uint256 vehicleId) returns (uint256 occupancy, uint256 capacity)`
- `getDemandForecast(uint256 routeId, uint256 timeframe) returns (uint256[] memory)`
- `getHistoricalRidership(uint256 routeId, uint256 startTime, uint256 endTime) returns (RidershipData memory)`

### 4. Schedule Optimization Contract

**Purpose**: Dynamically adjusts service schedules based on real-time demand and operational constraints.

**Key Features**:
- AI-powered schedule optimization algorithms
- Real-time service frequency adjustments
- Multi-objective optimization (efficiency, passenger satisfaction, cost)
- Event-based schedule modifications
- Weather and traffic integration
- Cross-route coordination
- Emergency service rerouting

**Functions**:
- `optimizeSchedule(uint256 routeId, uint256 timeWindow) returns (Schedule memory)`
- `adjustServiceFrequency(uint256 routeId, uint256 newFrequency, string reason)`
- `implementEmergencySchedule(uint256 routeId, Schedule memory emergencySchedule)`
- `getOptimizedDepartureTimes(uint256 routeId, uint256 date) returns (uint256[] memory)`
- `scheduleSpecialEvent(uint256 routeId, EventInfo memory eventDetails)`

### 5. Performance Measurement Contract

**Purpose**: Tracks service reliability, punctuality, and overall system performance metrics.

**Key Features**:
- On-time performance tracking
- Service reliability scoring
- Passenger satisfaction integration
- Asset utilization metrics
- Environmental impact measurement
- Cost efficiency analysis
- Benchmarking against performance standards

**Functions**:
- `recordArrival(uint256 vehicleId, address stopId, uint256 actualTime, uint256 scheduledTime)`
- `updateServiceReliability(uint256 routeId, uint256 reliabilityScore)`
- `trackMaintenanceEvents(uint256 vehicleId, MaintenanceRecord memory record)`
- `getPerformanceMetrics(uint256 routeId, uint256 timeframe) returns (PerformanceData memory)`
- `generateComplianceReport(address agency, uint256 period) returns (ComplianceReport memory)`

## Getting Started

### Prerequisites

- Node.js (v16 or later)
- Hardhat development environment
- IPFS node for decentralized data storage
- IoT sensor integration capabilities
- Web3 wallet for contract interactions

### Installation

```bash
# Clone the repository
git clone https://github.com/public-transport/decentralized-optimization.git
cd decentralized-optimization

# Install dependencies
npm install

# Compile smart contracts
npx hardhat compile

# Run comprehensive tests
npx hardhat test

# Deploy to testnet
npx hardhat run scripts/deploy.js --network goerli
```

### Configuration

1. **Environment Setup**:
   ```bash
   cp .env.example .env
   # Configure agency credentials and sensor API keys
   ```

2. **IoT Integration**:
   Configure sensor data feeds in `config/sensors.json`

3. **Geographic Setup**:
   Initialize location mappings in `scripts/setup-geography.js`

## Usage Examples

### For Transit Agencies

```javascript
// Register transit agency
await transitVerification.verifyTransitAgency(
  agencyAddress,
  governmentLicenseHash,
  "Metropolitan Transit Authority"
);

// Register new route
await routeRegistry.registerRoute(
  "Route 42 - Downtown Express",
  [stop1Address, stop2Address, stop3Address],
  1 // Bus service
);

// Optimize schedule based on current demand
const optimizedSchedule = await scheduleOptimization.optimizeSchedule(
  routeId,
  86400 // 24 hour optimization window
);
```

### For IoT Sensors and Data Providers

```javascript
// Record passenger boarding data
await ridershipTracking.recordBoardings(
  routeId,
  stopAddress,
  passengerCount,
  block.timestamp
);

// Update vehicle location and capacity
await ridershipTracking.updateVehicleStatus(
  vehicleId,
  currentLocation,
  currentOccupancy,
  maxCapacity
);
```

### For Performance Monitoring

```javascript
// Track on-time performance
await performanceMeasurement.recordArrival(
  vehicleId,
  stopAddress,
  actualArrivalTime,
  scheduledArrivalTime
);

// Generate performance report
const metrics = await performanceMeasurement.getPerformanceMetrics(
  routeId,
  2592000 // 30 days
);
```

## API Reference

### Events

The system emits comprehensive events for real-time monitoring:

- `AgencyVerified(address indexed agency, string jurisdiction, uint256 timestamp)`
- `RouteRegistered(uint256 indexed routeId, address indexed agency, string routeName)`
- `RidershipRecorded(uint256 indexed routeId, address stopId, uint256 count, uint8 direction)`
- `ScheduleOptimized(uint256 indexed routeId, uint256 oldFrequency, uint256 newFrequency)`
- `PerformanceUpdated(uint256 indexed routeId, uint256 onTimePercentage, uint256 reliabilityScore)`
- `ServiceAlert(uint256 indexed routeId, uint8 alertType, string message)`

### Data Structures

```solidity
struct Route {
    uint256 id;
    string name;
    address[] stops;
    uint8 transportMode;
    address operatingAgency;
    uint8 status;
    uint256 createdAt;
}

struct RidershipData {
    uint256 routeId;
    uint256 totalBoardings;
    uint256 totalAlightings;
    uint256 peakOccupancy;
    uint256 averageOccupancy;
    uint256 timeframe;
}

struct PerformanceData {
    uint256 routeId;
    uint256 onTimePercentage;
    uint256 reliabilityScore;
    uint256 averageDelay;
    uint256 serviceCompletionRate;
    uint256 passengerSatisfactionScore;
}
```

## Integration Guide

### IoT Sensor Integration

```javascript
// Example sensor data integration
const sensorData = {
  vehicleId: "BUS_001",
  routeId: 42,
  stopAddress: "0x1234...5678",
  passengerCount: 23,
  timestamp: Date.now(),
  sensorType: "INFRARED_COUNTER"
};

await integrateEntitySensorData(sensorData);
```

### Mobile App Integration

```javascript
// Real-time schedule queries for passenger apps
const nextDepartures = await scheduleOptimization.getNextDepartures(
  stopAddress,
  5 // next 5 departures
);

const currentOccupancy = await ridershipTracking.getCurrentOccupancy(vehicleId);
```

## Security and Privacy

### Data Protection
- **Zero-Knowledge Proofs**: Passenger privacy protection
- **Differential Privacy**: Anonymous ridership analytics
- **Encrypted Communications**: Secure sensor data transmission
- **Access Control**: Role-based contract permissions

### Operational Security
- **Multi-Signature**: Critical schedule changes require multiple approvals
- **Emergency Controls**: Circuit breakers for system-wide issues
- **Audit Trails**: Immutable records of all system changes
- **Disaster Recovery**: Decentralized backup and recovery procedures

## Governance

### Decentralized Decision Making
- **Transit Authority DAO**: Collaborative governance between agencies
- **Stakeholder Voting**: Community input on service changes
- **Proposal System**: Democratic route and schedule modifications
- **Transparency**: Public access to performance data and decisions

## Environmental Impact

### Sustainability Metrics
- **Carbon Footprint Tracking**: Emissions monitoring per route
- **Energy Efficiency**: Optimization for reduced energy consumption
- **Modal Shift Analysis**: Impact on private vehicle usage
- **Environmental Reporting**: Regular sustainability assessments

## Roadmap

### Phase 1: Foundation (Current)
- Core contract deployment
- Basic ridership tracking
- Simple schedule optimization
- Transit agency onboarding

### Phase 2: Advanced Features
- AI-powered predictive analytics
- Cross-city interoperability
- Real-time passenger information systems
- Dynamic pricing integration

### Phase 3: Smart City Integration
- Traffic management system integration
- Multi-modal journey planning
- Autonomous vehicle coordination
- Smart infrastructure connectivity

### Phase 4: Global Network
- International transit network
- Cross-border travel optimization
- Global best practices sharing
- Universal transit token system

## Testing

```bash
# Run unit tests
npm test

# Integration testing with mock IoT data
npm run test:integration

# Performance testing
npm run test:performance

# Security audit preparation
npm run audit:prepare
```

## Deployment

### Testnet Deployment
```bash
# Deploy to Polygon Mumbai testnet
npx hardhat run scripts/deploy.js --network mumbai

# Initialize with sample transit data
npx hardhat run scripts/initialize-sample-data.js --network mumbai
```

### Production Considerations
- Multi-chain deployment for redundancy
- IPFS cluster setup for metadata storage
- Oracle integration for external data feeds
- Monitoring and alerting infrastructure

## Contributing

We welcome contributions from transit agencies, developers, and urban planning experts:

- **Transit Operators**: Real-world testing and feedback
- **Developers**: Smart contract and integration improvements
- **Researchers**: Algorithm optimization and analysis
- **Community**: User experience and accessibility improvements

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Support and Community

- **Documentation**: [docs.publictransit.eth](https://docs.publictransit.eth)
- **Transit Authority Portal**: [agencies.publictransit.eth](https://agencies.publictransit.eth)
- **Community Forum**: [forum.publictransit.eth](https://forum.publictransit.eth)
- **Developer Support**: dev-support@publictransit.eth
- **Emergency Contact**: emergency@publictransit.eth

## Partnerships

### Transit Agencies
- Metropolitan Transportation Authority (MTA)
- Transport for London (TfL)
- Bay Area Rapid Transit (BART)
- Singapore Land Transport Authority (LTA)

### Technology Partners
- Chainlink (Oracle services)
- IPFS (Decentralized storage)
- IoTeX (IoT blockchain integration)
- Polygon (Scaling solutions)

## Research and Publications

- **Smart Cities Integration Study**: [research.publictransit.eth/smart-cities](https://research.publictransit.eth/smart-cities)
- **Environmental Impact Analysis**: [research.publictransit.eth/environment](https://research.publictransit.eth/environment)
- **Ridership Prediction Models**: [research.publictransit.eth/prediction](https://research.publictransit.eth/prediction)

---

**Disclaimer**: This system handles critical public infrastructure. Thorough testing, regulatory compliance, and failsafe mechanisms are essential before production deployment. Always maintain traditional backup systems during transition periods.

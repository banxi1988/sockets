import libc

public enum ErrorReason {
    case createSocketFailed
    case optionSetFailed(level: Int32, name: Int32, value: String)
    case optionGetFailed(level: Int32, name: Int32, type: String)
    case closeSocketFailed
    
    case pipeCreationFailed
    
    case selectFailed(
        reads: [Int32],
        writes: [Int32],
        errors: [Int32]
    )
    
    case localAddressResolutionFailed
    case remoteAddressResolutionFailed
    case ipAddressResolutionFailed
    case ipAddressValidationFailed(String)
    case failedToGetIPFromHostname(String)
    case unparsableBytes
    
    case connectFailed(scheme: String, hostname: String, port: Port)
    case connectTimedOut
    case readFailed
    case bindFailed
    case listenFailed
    case acceptFailed
    case writeFailed
    
    case unsupportedSocketAddressFamily(Int32)
    case concreteSocketAddressFamilyRequired
    
    case socketIsClosed
    
    case generic(String)
}

public struct SocketsError: Error {
    
    public let type: ErrorReason
    public let number: Int32
    
    public init(_ type: ErrorReason) {
        self.type = type
        self.number = errno //last reported error code
    }
    
    public init(message: String) {
        self.type = .generic(message)
        self.number = -1
    }

    public static let interruptedSystemCall: Int32 = EINTR
}

import Debugging

extension SocketsError: Debuggable {
    public var reason: String {
        switch type {
        case .createSocketFailed:
            return "Failed to create a socket"
        case .optionSetFailed:
            return "Option set failed"
        case .optionGetFailed:
            return "Option get failed"
        case .closeSocketFailed:
            return "Failed to close the socket"
        case .pipeCreationFailed:
            return "Failed to create a pipe"
        case .selectFailed:
            return "Select failed"
        case .localAddressResolutionFailed:
            return "Failed to resolve a local address"
        case .remoteAddressResolutionFailed:
            return "Failed to resolve a remote address"
        case .ipAddressResolutionFailed:
            return "Failed to resolve an IP address"
        case .ipAddressValidationFailed(let s):
            return "IP address validation failed: \(s)"
        case .failedToGetIPFromHostname(let s):
            return "Failed to get IP from hostname: \(s)"
        case .unparsableBytes:
            return "Encountered unparsable bytes"
        case .connectFailed(let scheme, let hostname, let port):
            return "Failed trying to connect to \(scheme)://\(hostname):\(port)"
        case .connectTimedOut:
            return "Connection timed out"
        case .writeFailed:
            return "Failed to write from socket"
        case .readFailed:
            return "Failed trying to read from socket"
        case .bindFailed:
            return "Failed trying to bind to the address"
        case .listenFailed:
            return "Failed trying to start listening on the socket"
        case .acceptFailed:
            return "Failed trying to accept a new connection"
        case .unsupportedSocketAddressFamily:
            return "Unsupported socket address family"
        case .concreteSocketAddressFamilyRequired:
            return "Concrete socket address family required"
        case .socketIsClosed:
            return "Socket is closed"
        case .generic(let s):
            return s
        }
    }

    public var identifier: String {
        switch type {
        case .createSocketFailed:
            return "createSocketFailed"
        case .optionSetFailed:
            return "optionSetFailed"
        case .optionGetFailed:
            return "optionGetFailed"
        case .closeSocketFailed:
            return "closeSocketFailed"
        case .pipeCreationFailed:
            return "pipeCreationFailed"
        case .selectFailed:
            return "selectFailed"
        case .localAddressResolutionFailed:
            return "localAddressResolutionFailed"
        case .remoteAddressResolutionFailed:
            return "remoteAddressResolutionFailed"
        case .ipAddressResolutionFailed:
            return "ipAddressResolutionFailed"
        case .ipAddressValidationFailed:
            return "ipAddressValidationFailed"
        case .failedToGetIPFromHostname:
            return "failedToGetIPFromHostname"
        case .unparsableBytes:
            return "unparsableBytes"
        case .connectFailed:
            return "connectFailed"
        case .connectTimedOut:
            return "connectTimedOut"
        case .writeFailed:
            return "writeFailed"
        case .readFailed:
            return "readFailed"
        case .bindFailed:
            return "bindFailed"
        case .listenFailed:
            return "listenFailed"
        case .acceptFailed:
            return "acceptFailed"
        case .unsupportedSocketAddressFamily:
            return "unsupportedSocketAddressFamily"
        case .concreteSocketAddressFamilyRequired:
            return "concreteSocketAddressFamilyRequired"
        case .socketIsClosed:
            return "socketIsClosed"
        case .generic:
            return "generic"
        }
    }

    public var possibleCauses: [String] {
        switch type {
        case .acceptFailed:
            return ["`bind` has not been called first", "`listen` has not been called first"]
        case .listenFailed:
            return ["`bind` has not been called first"]
        case .connectFailed:
            return ["The hostname or port is not valid"]
        default:
            return []
        }
    }

    public var suggestedFixes: [String] {
        return []
    }
}

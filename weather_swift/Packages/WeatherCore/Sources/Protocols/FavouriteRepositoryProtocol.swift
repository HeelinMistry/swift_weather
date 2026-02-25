//
//  FavouriteRepositoryProtocol.swift
//  WeatherCore
//
//  Created by Heelin Mistry on 2026/02/23.
//

/// A repository interface for managing persisted favourite locations.
///
/// `FavouriteRepositoryProtocol` defines the required functionality
/// for retrieving, saving, and deleting user-selected favourite locations.
///
/// Conforming types are responsible for handling the underlying
/// storage mechanism (e.g. database, file system, UserDefaults, or remote API).
///
/// ## Usage
/// ```swift
/// let repository: FavouriteRepositoryProtocol = FavouriteRepository()
/// let favourites = try repository.getFavourites()
/// ```
///
/// ## Topics
/// ### Managing Favourites
/// - ``getFavourites()``
/// - ``saveFavourite(_:)``
/// - ``deleteFavourite(_:)``
public protocol FavouriteRepositoryProtocol {

    /// Returns all stored favourite locations.
    ///
    /// - Returns: An array of `FavouriteLocation` values.
    ///
    /// - Throws: An error if the favourites could not be loaded
    ///   due to a decoding failure, storage issue, or permission problem.
    func getFavourites() async throws -> [FavouriteLocation]

    /// Persists a location as a favourite.
    ///
    /// If the location already exists, the implementation may either
    /// update the existing entry or ignore the request.
    ///
    /// - Parameter location: The location to be saved as a favourite.
    ///
    /// - Throws: An error if the location could not be saved
    ///   due to a storage failure or validation error.
    func saveFavourite(_ location: FavouriteLocation) async throws

    /// Removes a location from the stored favourites.
    ///
    /// If the specified location does not exist, implementations
    /// may choose to silently ignore the request.
    ///
    /// - Parameter location: The location to remove.
    ///
    /// - Throws: An error if the location could not be deleted
    ///   due to a storage or permission failure.
    func deleteFavourite(_ location: FavouriteLocation) async throws
}

import Leaf
import Vapor
import Fluent
import FluentSQLite

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

  // setups up the Leaf Renderer service
  try services.register(LeafProvider())
  config.prefer(LeafRenderer.self, for: ViewRenderer.self)
  
  // finds where we are direcotry wise and shares it with the vapor server
  let directoryConfig = DirectoryConfig.detect()
  services.register(directoryConfig)
  
  try services.register(FluentSQLiteProvider())
  
  // configuration for database
  var databaseConfig = DatabasesConfig()
  let db = try SQLiteDatabase(storage: .file(path:"\(directoryConfig.workDir)cupcakes.db"))
  databaseConfig.add(database: db, as: .sqlite)
  services.register(databaseConfig)
  
  var migrationConfig = MigrationConfig()
  migrationConfig.add(model: Cupcake.self, database: .sqlite)
  migrationConfig.add(model: Order.self, database: .sqlite)
  services.register(migrationConfig)
}

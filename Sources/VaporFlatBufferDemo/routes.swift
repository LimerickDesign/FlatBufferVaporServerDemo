import Vapor
import FlatBuffers

typealias Monster = MyGame.Sample.Monster
typealias Weapon = MyGame.Sample.Weapon
typealias Color = MyGame.Sample.Color
typealias Vec3 = MyGame.Sample.Vec3

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }
    
    app.get("monster") { (req: Request) -> Response in
        let expectedDMG: [Int16] = [3, 5]
        let expectedNames = ["Sword", "Axe"]

        let builder = FlatBufferBuilder(initialSize: 1024)
        let weapon1Name = builder.create(string: expectedNames[0])
        let weapon2Name = builder.create(string: expectedNames[1])
            
        let weapon1Start = Weapon.startWeapon(builder)
        Weapon.add(name: weapon1Name, builder)
        Weapon.add(damage: expectedDMG[0], builder)
        let sword = Weapon.endWeapon(builder, start: weapon1Start)
        let weapon2Start = Weapon.startWeapon(builder)
        Weapon.add(name: weapon2Name, builder)
        Weapon.add(damage: expectedDMG[1], builder)
        let axe = Weapon.endWeapon(builder, start: weapon2Start)

        let name = builder.create(string: "Orc")
        let inventory: [Byte] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let inventoryOffset = builder.createVector(inventory)

        let weaponsOffset = builder.createVector(ofOffsets: [sword, axe])
        let pos = builder.create(struct: MyGame.Sample.createVec3(x: 1, y: 2, z: 3), type: Vec3.self)


        let orc = Monster.createMonster(builder,
                                        offsetOfPos: pos,
                                        hp: 300,
                                        offsetOfName: name,
                                        vectorOfInventory: inventoryOffset,
                                        color: .red,
                                        vectorOfWeapons: weaponsOffset,
                                        equippedType: .weapon,
                                        offsetOfEquipped: axe)
        builder.finish(offset: orc)

        let response = Response()
        response.status = .ok
        response.body = .init(data: builder.data)
        return response
    }
}

# WannaBasket
Xcode Project for BECORD iOS Application

</br>

## VIPER
하나의 모듈을 5개의 레이어로 나누어 구현하는 아키텍처

#### 장점
- 아키텍처를 쓰는 목적 = **관심사**의 분리 = **VIPER**
- 모듈이 관심사에 따라 잘 나누어져, 개발하면서 길을 잃지 않는다.
- 동시간 협업과 테스트가 용이하다.

#### 단점
- 단순한 모듈을 만드는 일에도 소요가 큰 편이다.
- 레이어 간 잦은 데이터 이동, 변환을 관리해야 한다.

#### 레이어
- **V** iew : 프레젠터에게 데이터를 받아 화면에 보여준다. 사용자 이벤트를 프레젠터에게 알려준다.
- **I** nteractor : 프레젠터의 요청에 따라 Entity와 통신하여, 데이터를 보내주거나 가공한다.
- **P** resenter : 뷰가 알려준 사용자 이벤트에 따라 뷰에 데이터를 보내주거나, 인터랙터에게 데이터를 요청하는 등의 처리를 해준다.
- **E** ntity : 데이터의 원본 객체 (ex: Realm, FireStore)
- **R** outer : 모듈간의 전환을 담당한다.

</br>

## Module Enumeration

- 모든 모듈은 모듈 열거형을 통해 생성한다.
- 모듈이 아무리 많아져도 열거형만 잘 관리해주면 된다.
- 어떤 모듈이 존재하고, 각 모듈이 어떤 데이터를 필요로 하는지 쉽게 확인할 수 있다.
```Swift
enum Module {

    case Home
    case Game(game: Game)

    var view: UIViewController {
      switch self {
        case .Home:
        return HomeWireframe.createModule()
        case .Game(let game):
        return GameWireframe.createModule(with: game)
      }
    }
}
```

</br>

## Realm

- 간단한 코드로 NoSQL 로컬 데이터베이스를 구축할 수 있다.
- Realm Database 싱글턴 객체 
- Realm Object에 공통으로 쓰일 프로퍼티나 메소드를 구현
- 특정 Realm Object에 쓰일 메소드는 프로토콜을 통해 확장
- Realm Database는 Interactor 레이어를 통해서 접근

</br>

## Persistable

- RealmObject는 Realm Database의 인스턴스만이 다룰 수 있게 한다.
- VIPER의 모든 레이어는 RealmObject의 Value-Type Object만을 다룬다.
- Persistable은 **RealmObject와 Value-Type Object 사이의 변환**을 담당한다.

```swift
protocol Persistable {
		associatedtype RealmObject: RealmSwift.Object
  
  	// RealmObject to Value-Type Object
    init(realmObject: RealmObject)
  
  	// Value-Type Object to RealmObject
    func realmObject() -> RealmObject
}
```


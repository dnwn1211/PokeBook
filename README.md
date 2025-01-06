# Pokemon App README

## **프로젝트 개요**
이 프로젝트는 포켓몬 컬렉션 앱으로, 포켓몬 목록을 표시하고 각 포켓몬에 대한 상세 정보를 제공합니다. 앱은 MVVM 아키텍처를 기반으로 구축되었으며, RxSwift를 활용한 반응형 프로그래밍을 적용했습니다.

---

## **주요 기능**

1. **포켓몬 목록 보기**
   - `UICollectionView`를 사용하여 포켓몬을 그리드로 표시.
   - 무한 스크롤을 지원하여 동적으로 더 많은 포켓몬을 로드.
   - Kingfisher를 활용하여 포켓몬 이미지를 효율적으로 가져오고 캐싱.

2. **상세 보기**
   - 선택한 포켓몬의 상세 정보를 표시.
   - 선택한 포켓몬에 따라 내용을 동적으로 업데이트.

3. **MVVM 아키텍처**
   - `View`, `ViewModel`, `Model` 간의 관심사 분리.
   - 코드 가독성, 테스트 가능성, 유지 보수성 향상.

4. **반응형 프로그래밍**
   - RxSwift와 RxCocoa를 사용하여 UI 바인딩 및 비동기 이벤트 처리.
   - 간결하고 선언적인 상태 관리.

---

## **사용 기술**

- **Swift**: 주요 프로그래밍 언어.
- **RxSwift/RxCocoa**: 반응형 프로그래밍 및 UI 바인딩에 활용.
- **Kingfisher**: 효율적인 이미지 가져오기 및 캐싱.
- **UIKit**: 앱 UI 생성 및 관리.
- **PokeAPI**: 포켓몬 데이터 소스.

---

## **아키텍처**

### **MVVM 구조**

1. **View**
   - UI와 사용자 상호작용을 처리.
   - 예: `MainViewController`, `DetailViewController`.

2. **ViewModel**
   - Model과 View 간의 데이터 흐름 관리.
   - 데이터를 변환하고 View에 표시할 준비를 함.
   - 예: `MainViewModel`, `DetailViewModel`.

3. **Model**
   - 데이터 구조를 나타내고 API 호출 처리.
   - 예: `PokemonService`, `Pokemon`.

---

## **코드 개요**

### **MainViewController**
포켓몬 목록을 표시하고 사용자 상호작용을 처리합니다.

- **주요 함수:**
  - 포켓몬을 표시하기 위해 `UICollectionView` 설정.
  - 사용자 상호작용(예: 아이템 선택, 무한 스크롤)을 ViewModel에 바인딩.
  - 포켓몬 선택 시 `DetailViewController`로 이동.

### **MainViewModel**
비즈니스 로직을 처리하고 Model과 통신하여 포켓몬 데이터를 가져옵니다.

- **입력:**
  - `loadMoreTrigger`: 추가 포켓몬을 로드하는 트리거.
  - `selectPokemonTrigger`: 특정 포켓몬을 선택하는 트리거.

- **출력:**
  - `pokemonList`: 표시할 포켓몬 목록 방출.
  - `selectedPokemon`: 선택한 포켓몬의 세부정보 방출.
  - `error`: 에러 메시지 방출.

### **PokemonService**
PokeAPI로부터 포켓몬 데이터를 가져오는 메서드를 제공합니다.

- **함수:**
  - `fetchPokemonList() -> Observable<[Pokemon]>`
  - `fetchPokemonDetail(id: Int) -> Observable<PokemonDetail>`

---

## **설치 및 실행**

1. **레포지토리 클론:**
   ```bash
   git clone https://github.com/your-username/pokemon-app.git
   cd pokemon-app
   ```

2. **의존성 설치:**
   CocoaPods가 설치되어 있는지 확인한 후 다음 명령어를 실행하세요:
   ```bash
   pod install
   ```

3. **프로젝트 열기:**
   `.xcworkspace` 파일을 Xcode에서 엽니다.

4. **앱 실행:**
   시뮬레이터 또는 디바이스를 선택한 후 `Cmd+R`을 눌러 앱을 실행하세요.



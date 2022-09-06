# 워크앳, 카공 카페 지도 Work At

## 본 프로젝트는 간단한 기획과 함께 빠른 MVP를 제작하여 배포하고 발전시켜 나가자는 취지하에 진행된 개인 프로젝트입니다.

아래 제 블로그 글을 통해 기획과 개발 과정에 대한 이야기를 자세히 확인할 수 있습니다.<br/>
https://velog.io/@rjsgy0815/Flutter-카공-카페-지도-서비스

### Development Enviroment
- Mac OS Monterey, Intellij, IPhone 13, Android Emulator
- Flutter, Firebase, Naver Map, Git

## Ver 1.0.0
### #1 지도 기능
- **기능**
<br/>카페 리스트를 지도에서 확인할 수 있습니다.


- **구현**
<br/>Naver Map API를 사용하였습니다.
<br/>현재 Naver에서 Flutter 공식 Naver Map API를 제공하지 않습니다.
<br/>Pub.dev에서 Naver Map API를 사용할 수 있는 라이브러는 총 2개인데 그 중 업데이트가 비교적 최신인 flutter_naver_map 라이브러리를 사용하였습니다.
<br/>Flutter 2.0의 Null Safety는 대응이 되어있었으나 Flutter 3.0 에는 아직 대응이 되지 않아 Android 환경에서 사용이 불가합니다.
<br/>따라서 해당 라이브러리를 @jinu0321 님께서 수정하신 코드를 사용하였습니다.
<br/><br/>카페 정보의 경우 Firebase Firestore DB를 사용하였습니다.
<br/>Collection-Key 방식으로 각 점포별로 데이터를 관리하기 용이하여 추후 관계형 데이터베이스에 대한 필요성이 대두될때까지 유지할 생각입니다.
### #2 북마크 기능
- **기능**
<br/>원하는 카페를 모아볼 수 있습니다.


- **구현**
<br/>빠른 구현을 위해 로컬 DB를 사용하였습니다.
<br/>SQLite를 사용하였고 카페 아이디를 저장하는 방식으로 간단히 구현하였습니다.
<br/>실제 화면에서의 원활한 북마크 인터랙션은 Provider를 활용한 상태관리를 통해 DB 동기화와 함께 변화되도록 구현하였습니다.
<br/><br/>
### #3 정보 수정 요청 기능
- **기능**
<br/>잘못된 정보를 유저가 수정 요청할 수 있습니다.


- **구현**
<br/>회원가입 등의 유저 관리를 구현하지 않았기 때문에 직접 수정은 불가능하도록 하였습니다.
<br/>그러나 수정 소요에 대응하기 위하여 직접 폼을 통해 요청할 수 있도록 간단히 처리하였습니다.
<br/>요청 사항은 Firebase Firestore에 저장됩니다.
<br/><br/>
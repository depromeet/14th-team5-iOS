//
//  SectionOfFamily.swift
//  App
//
//  Created by 마경미 on 07.12.23.
//

import RxDataSources
import Domain

struct FamilySection {
    typealias Model = SectionModel<Int, Item>
    
    /// NOTE: - FamilySection의 Item 타입으로 `MainFamilyReactor`로 가져야
    /// `MainViewReactor`에서 `MainFamilyCellReactor`를 생성할 때, `GlobalState(Service)`를 주입시킬 수 있습니다.
    /// 하지만, `FamilySection`이 `Domain` 모듈에 위치할 경우, `App` 모듈에 접근할 수 없어
    /// `MainFamilyCellReactor`를 Item 타입으로 지정할 수 없는 건 물론, 뷰 컨트롤러에게 Item을 넘겨주고 cell의 Reactor를 주입하는 과정이 무척이나 번거로워집니다.
    ///
    /// 아울러, `Entity`는 비즈니스 로직의 한 축을 이루는 원천 데이터인 반면,
    /// `RxDatasource` 테이블을 구성하는 데 필요한 `ModelType`은 UI 구성에 조금 더 가깝지 않나라는 개인적인 견해도 가지고 있습니다.
    ///
    /// 이와 관련된 코드는 `PostSectionModel`과 `CommentViewReactor`를 참조하시면 됩니다.
    /// 추가 자료는 [여기](https://ios-development.tistory.com/796)에서 확인하실 수 있습니다.
    ///
    /// 회의 때 더 자세히 설명드릴게요.
    
    enum Item {
        case main(MainFamilyCellReactor)
    }
}

extension FamilySection.Item: Equatable { }

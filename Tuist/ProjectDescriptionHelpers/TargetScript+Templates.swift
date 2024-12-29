//
//  TargetScript+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 김도현 on 12/12/24.
//

import ProjectDescription
import Foundation


public extension TargetScript {
    static let firebaseCrashlytics = TargetScript.post(
        script: """
          case "${CONFIGURATION}" in
          "PRD" | "Release" )
          BASE_PATH=$(realpath "${SRCROOT}/../..")
          "${BASE_PATH}/Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"   -gsp "${BASE_PATH}/14th-team5-iOS/App/Resources/GoogleService-Info.plist"   -p ios "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
          esac
          """,
        name: "Firebase Crashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
            "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
        ],
        basedOnDependencyAnalysis: false
    )
}

/*
 InfinitePagingView.swift
StampRecord

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum PageDirection {
    case backward
    case forward

    var baseIndex: Int {
        switch self {
        case .backward:
            return 0
        case .forward:
            return 2
        }
    }
}

struct Page<T: Hashable>: Hashable, Identifiable {
    var id = UUID()
    var index: Int
    var object: T
}

struct InfinitePagingView<T: Hashable, Content: View>: View {
    @Binding var objects: [T]
    @State var title: String = ""
    @State var pages: [Page<T>]
    @State var selection: Page<T>
    @State var previousPage: Page<T>
    private let pagingHandler: (PageDirection) -> Void
    private let content: (T) -> Content

    init(
        objects: Binding<[T]>,
        pagingHandler: @escaping (PageDirection) -> Void,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        assert(objects.wrappedValue.count == 3, "objects.count must be 3.")
        _objects = objects
        let pages = (0 ..< 3).map { Page(index: $0, object: objects.wrappedValue[$0]) }
        _pages = State(initialValue: pages)
        _selection = State(initialValue: pages[1])
        _previousPage = State(initialValue: pages[1])
        self.pagingHandler = pagingHandler
        self.content = content
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(pages) { page in
                content(page.object)
                    .tag(page)
                    .onDisappear {
                        pagingIfNeeded()
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: objects) { _ in
            updatePages()
        }
    }

    private func pagingIfNeeded() {
        if selection.index < previousPage.index {
            pagingHandler(.backward)
        } else if previousPage.index < selection.index {
            pagingHandler(.forward)
        }
    }

    private func updatePages() {
        pages = zip(pages, objects).map { (page, object) in
            return Page(id: page.id, index: page.index, object: object)
        }
        selection = pages[1]
        previousPage = selection
    }
}

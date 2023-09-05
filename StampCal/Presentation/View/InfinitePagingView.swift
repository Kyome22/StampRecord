/*
 InfinitePagingView.swift
 StampCal

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
    var object: T
}

struct InfinitePagingView<T: Hashable, Content: View>: View {
    @Binding var objects: [T]
    @State var title: String = ""
    @State var pages: [Page<T>]
    @State var selection: UUID
    @State var selectionChanged: Bool = false
    @State var updated: Bool = false
    private let pagingHandler: (PageDirection) -> Void
    private let content: (T) -> Content

    init(
        objects: Binding<[T]>,
        pagingHandler: @escaping (PageDirection) -> Void,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        assert(objects.wrappedValue.count == 3, "objects.count must be 3.")
        _objects = objects
        let pages = objects.wrappedValue.map { Page(object: $0) }
        _pages = State(initialValue: pages)
        _selection = State(initialValue: pages[1].id)
        self.pagingHandler = pagingHandler
        self.content = content
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(pages) { page in
                content(page.object)
                    .tag(page.id)
                    .onDisappear {
                        update(previousPage: page)
                    }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onChange(of: selection) { _ in
            if updated {
                updated = false
            } else {
                selectionChanged = true
            }
        }
        .onChange(of: objects) { _ in
            updatePages()
        }
    }

    private func update(previousPage: Page<T>) {
        guard selectionChanged else { return }
        selectionChanged = false
        updated = true

        let previousIndex = pages.firstIndex(of: previousPage)!
        let currentIndex = pages.firstIndex(where: { $0.id == selection })!
        let diff = currentIndex - previousIndex

        if diff == -1 {
            pagingHandler(.backward)
        }
        if diff == 1 {
            pagingHandler(.forward)
        }
    }

    private func updatePages() {
        pages = zip(pages, objects).map { (page, object) in
            return Page(id: page.id, object: object)
        }
        selection = pages[1].id
    }
}

.pragma library

const fileParser = {
    readFile: function(filePath) {
        try {
            const file = new XMLHttpRequest()
            file.open("GET", filePath, false)
            file.send()
            return file.responseText
        } catch (e) {
            return ""
        }
    },

    getFileName: function(filePath) {
        return filePath.split('/').pop() || "File"
    },

    detectFileType: function(filePath) {
        const name = this.getFileName(filePath).toLowerCase()
        if (name.endsWith('.md') || name.endsWith('.markdown')) return "markdown"
        if (name.endsWith('.js') || name.endsWith('.ts') || name.endsWith('.jsx') || name.endsWith('.tsx')) return "code"
        if (name.endsWith('.py') || name.endsWith('.rb') || name.endsWith('.go') || name.endsWith('.rs')) return "code"
        if (name.endsWith('.json') || name.endsWith('.yaml') || name.endsWith('.yml') || name.endsWith('.toml')) return "code"
        if (name.endsWith('.html') || name.endsWith('.css') || name.endsWith('.xml')) return "code"
        if (name.endsWith('.txt') || name.endsWith('.sh') || name.endsWith('.bash') || name.endsWith('.zsh')) return "code"
        return "text"
    },

    parseMarkdown: function(text) {
        const lines = text.split('\n')
        const result = []
        let i = 0

        while (i < lines.length) {
            const line = lines[i]
            const trimmed = line.trim()

            if (trimmed.startsWith('#')) {
                const level = trimmed.match(/^#+/)[0].length
                const content = trimmed.substring(level).trim()
                result.push({
                    type: "heading",
                    level: level,
                    content: content
                })
                i++
            }
            else if (trimmed.startsWith('```')) {
                const lang = trimmed.substring(3).trim()
                i++
                let code = ""
                while (i < lines.length && !lines[i].trim().startsWith('```')) {
                    code += lines[i] + "\n"
                    i++
                }
                result.push({
                    type: "code",
                    content: code.trim(),
                    language: lang
                })
                i++
            }
            else if (trimmed.startsWith('>')) {
                let quote = trimmed.substring(1).trim()
                i++
                while (i < lines.length && lines[i].trim().startsWith('>')) {
                    quote += " " + lines[i].trim().substring(1).trim()
                    i++
                }
                result.push({
                    type: "blockquote",
                    content: quote
                })
            }
            else if (trimmed === '---' || trimmed === '***' || trimmed === '___') {
                result.push({ type: "hr" })
                i++
            }
            else if (trimmed.match(/^[-*+]\s/)) {
                let items = []
                while (i < lines.length && lines[i].trim().match(/^[-*+]\s/)) {
                    items.push(lines[i].trim().substring(2))
                    i++
                }
                result.push({
                    type: "list",
                    items: items
                })
            }
            else if (trimmed !== "") {
                let para = trimmed
                i++
                while (i < lines.length && lines[i].trim() !== "" &&
                       !lines[i].trim().match(/^[#`>-*+]/) &&
                       !lines[i].trim().startsWith('```')) {
                    para += " " + lines[i].trim()
                    i++
                }
                result.push({
                    type: "paragraph",
                    content: para
                })
            }
            else {
                i++
            }
        }

        return result
    },

    fuzzyMatch: function(query, text) {
        const q = query.toLowerCase()
        const t = text.toLowerCase()
        let score = 0
        let qIdx = 0
        let prevWasGap = true

        for (let i = 0; i < t.length && qIdx < q.length; i++) {
            if (t[i] === q[qIdx]) {
                score += prevWasGap ? 10 : 1
                prevWasGap = false
                qIdx++
            } else {
                prevWasGap = t[i] === '/' || t[i] === '-' || t[i] === '_'
            }
        }

        return qIdx === q.length ? score : 0
    },

    fuzzySearchFiles: function(query, files) {
        if (!query || query.length === 0) return files

        const scored = files.map(file => {
            const nameScore = this.fuzzyMatch(query, file.name)
            const pathScore = this.fuzzyMatch(query, file.path) * 0.5
            const obj = {}
            for (let key in file) {
                obj[key] = file[key]
            }
            obj.score = Math.max(nameScore, pathScore)
            return obj
        })

        return scored
            .filter(f => f.score > 0)
            .sort((a, b) => b.score - a.score)
            .map(f => {
                const result = {}
                for (let key in f) {
                    if (key !== 'score') {
                        result[key] = f[key]
                    }
                }
                return result
            })
    },

    extractTitle: function(filePath) {
        const content = this.readFile(filePath)
        const lines = content.split('\n')

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim()
            if (line.startsWith('#')) {
                return line.replace(/^#+\s*/, '')
            }
            if (line !== "") {
                return line.substring(0, 50)
            }
        }

        return this.getFileName(filePath)
    }
}

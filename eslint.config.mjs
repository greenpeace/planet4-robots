import { defineConfig } from "eslint/config";
import globals from "globals";
import path from "node:path";
import { fileURLToPath } from "node:url";
import js from "@eslint/js";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

export default defineConfig([{
    extends: compat.extends("eslint:recommended"),

    languageOptions: {
        globals: {
            ...globals.node,
        },

        ecmaVersion: 8,
        sourceType: "commonjs",
    },

    rules: {
        indent: ["error", 2],
        "linebreak-style": ["error", "unix"],

        quotes: ["error", "double", {
            allowTemplateLiterals: true,
        }],

        semi: ["error", "always"],
        curly: ["error", "all"],
        "one-var-declaration-per-line": ["error", "always"],
        "new-cap": "error",
    },
}]);
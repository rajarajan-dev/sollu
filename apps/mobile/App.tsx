import './global.css'
import { StatusBar } from 'expo-status-bar'
import { Text, View } from 'react-native'
import { formatDate } from '@repo/shared'

export default function App() {
  return (
    <View className="flex-1 bg-orange-400 items-center justify-center gap-2">
      <Text className="text-3xl font-bold">sollu</Text>
      <Text className="text-sm text-gray-400">{formatDate(new Date().toISOString())}</Text>
      <StatusBar style="auto" />
    </View>
  )
}

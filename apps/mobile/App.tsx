import { StatusBar } from 'expo-status-bar'
import { StyleSheet, Text, View } from 'react-native'
import { formatDate } from '@repo/shared'

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>sollu</Text>
      <Text style={styles.date}>{formatDate(new Date().toISOString())}</Text>
      <StatusBar style="auto" />
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
  },
  title: { fontSize: 28, fontWeight: '700' },
  date: { fontSize: 13, color: '#999' },
})
